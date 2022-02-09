Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ED624AF583
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 16:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234619AbiBIPjG convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 9 Feb 2022 10:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236071AbiBIPjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 10:39:05 -0500
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.85.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E9ABEC061355
        for <stable@vger.kernel.org>; Wed,  9 Feb 2022 07:39:07 -0800 (PST)
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-266-CLFZHHFuMYWxCblHNniABg-1; Wed, 09 Feb 2022 15:39:04 +0000
X-MC-Unique: CLFZHHFuMYWxCblHNniABg-1
Received: from AcuMS.Aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) by
 AcuMS.aculab.com (fd9f:af1c:a25b:0:994c:f5c2:35d6:9b65) with Microsoft SMTP
 Server (TLS) id 15.0.1497.28; Wed, 9 Feb 2022 15:39:02 +0000
Received: from AcuMS.Aculab.com ([fe80::994c:f5c2:35d6:9b65]) by
 AcuMS.aculab.com ([fe80::994c:f5c2:35d6:9b65%12]) with mapi id
 15.00.1497.028; Wed, 9 Feb 2022 15:39:02 +0000
From:   David Laight <David.Laight@ACULAB.COM>
To:     'Aditya Garg' <gargaditya08@live.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        "joeyli.kernel@gmail.com" <joeyli.kernel@gmail.com>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "eric.snowberg@oracle.com" <eric.snowberg@oracle.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        "jlee@suse.com" <jlee@suse.com>,
        "James.Bottomley@hansenpartnership.com" 
        <James.Bottomley@HansenPartnership.com>,
        "jarkko@kernel.org" <jarkko@kernel.org>,
        "mic@digikod.net" <mic@digikod.net>,
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: RE: [PATCH] efi: Do not import certificates from UEFI Secure Boot for
 T2 Macs
Thread-Topic: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Thread-Index: AQHYHcE4Urimp9LpDkeI7ezkgv1YDayLWeDg
Date:   Wed, 9 Feb 2022 15:39:02 +0000
Message-ID: <755cffe1dfaf43ea87cfeea124160fe0@AcuMS.aculab.com>
References: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
In-Reply-To: <9D0C961D-9999-4C41-A44B-22FEAF0DAB7F@live.com>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.202.205.107]
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=C51A453 smtp.mailfrom=david.laight@aculab.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aditya Garg
> Sent: 09 February 2022 14:28
> 
> On T2 Macs, the secure boot is handled by the T2 Chip. If enabled, only
> macOS and Windows are allowed to boot on these machines. Thus we need to
> disable secure boot for Linux. If we boot into Linux after disabling
> secure boot, if CONFIG_LOAD_UEFI_KEYS is enabled, EFI Runtime services
> fail to start, with the following logs in dmesg
> 
..
> +static const struct dmi_system_id uefi_apple_ignore[] = {
> +	{
> +		 .matches = {
> +			DMI_MATCH(DMI_BOARD_VENDOR, "Apple Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "MacBookPro15,1"),
> +		},

I think I'd use:
#define xxx(vendor, product) \
		 .matches = {
			DMI_MATCH(DMI_BOARD_VENDOR, vendor), \
			DMI_MATCH(DMI_PRODUCT_NAME, product), \
		}
somewhere with a suitable name (bikeshed blue) to reduce
the code size of this table.

	David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
Registration No: 1397386 (Wales)

