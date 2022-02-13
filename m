Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 579DA4B3DC5
	for <lists+stable@lfdr.de>; Sun, 13 Feb 2022 22:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238431AbiBMVdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Feb 2022 16:33:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231563AbiBMVdo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Feb 2022 16:33:44 -0500
Received: from cavan.codon.org.uk (cavan.codon.org.uk [176.126.240.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92F6554184;
        Sun, 13 Feb 2022 13:33:34 -0800 (PST)
Received: by cavan.codon.org.uk (Postfix, from userid 1000)
        id 858A440A6A; Sun, 13 Feb 2022 21:33:32 +0000 (GMT)
Date:   Sun, 13 Feb 2022 21:33:32 +0000
From:   Matthew Garrett <mjg59@srcf.ucam.org>
To:     Aditya Garg <gargaditya08@live.com>
Cc:     Ard Biesheuvel <ardb@kernel.org>, Jeremy Kerr <jk@ozlabs.org>,
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
        "dmitry.kasatkin@gmail.com" <dmitry.kasatkin@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        Orlando Chamberlain <redecorating@protonmail.com>,
        Aun-Ali Zaidi <admin@kodeit.net>
Subject: Re: [PATCH] efi: Do not import certificates from UEFI Secure Boot
 for T2 Macs
Message-ID: <20220213213332.GA30613@srcf.ucam.org>
References: <5A3C2EBF-13FF-4C37-B2A0-1533A818109F@live.com>
 <20220209183545.GA14552@srcf.ucam.org>
 <20220209193705.GA15463@srcf.ucam.org>
 <2F1CC5DE-5A03-46D2-95E7-DD07A4EF2766@live.com>
 <20220210180905.GB18445@srcf.ucam.org>
 <99BB011C-71DE-49FA-81CB-BE2AC9613030@live.com>
 <20220211162857.GB10606@srcf.ucam.org>
 <F078BEBE-3DED-4EE3-A2B8-2C5744B5454C@live.com>
 <20220212194240.GA4131@srcf.ucam.org>
 <C737F740-9039-4730-9F08-9E9E9674B6C8@live.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <C737F740-9039-4730-9F08-9E9E9674B6C8@live.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Feb 13, 2022 at 08:22:32AM +0000, Aditya Garg wrote:

> Surprisingly it didn’t cause a crash. The logs are at https://gist.githubusercontent.com/AdityaGarg8/8e820c2724a65fb4bbb5deae2b358dc8/raw/2a003ef43ae06dbe2bcc22b34ba7ccbb03898a21/log2.log

Interesting. Ok, so there's something else going on here. I'll have 
access to a T2 system next week, so I'll take a look then. Is this 
something that started happening recently, or has it always happened if 
this config option is set on these platforms?
