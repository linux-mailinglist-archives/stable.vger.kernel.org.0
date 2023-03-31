Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CDCD6D20F4
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 14:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231868AbjCaMyZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 08:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCaMyY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 08:54:24 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29B43114
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:54:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id x15so20327843pjk.2
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 05:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680267262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lXs91J9VBWYWF6vFvNtD31m36D/rVCF8nUTP5GNSUFo=;
        b=FpNuCHul5C0/c3JkwPDrG+rakbw19RoRSKbnYpCAR+/em3qrdiw+fnPqgAuifup+zP
         y7yGYXRJrINXxMV6MEiqHqSkafAcwedcfYO8CA0k1HroPCw85vwfnhsO0PGXWd0bvV0H
         9I22ctHN5LVISzp5bvn7N66luDfGo9U7LpC2UFeXqxR4APySmcFjx52o2JwEC/WvYDQl
         jz1PvriXkbvtfeTObR6Bhk99B6gNLiUDxth9xnFG+cjCcNtzFJ6t/kC/iKEKib159clQ
         pJmH9jzbzLd8fQJM3M8xkpsHKrWjoOTX8HbCVxgTQAiy0kgmxnET7RYdyoyqPQadxwFn
         asJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680267262;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lXs91J9VBWYWF6vFvNtD31m36D/rVCF8nUTP5GNSUFo=;
        b=Wbfc8XIuCUhuiwo3DvfE3JHLeVg08een5LK/lWY34XNqA8FJFolJlxP5p6LRg8+WH0
         ntfUxJavrRzqjVWcl9OX8sMJf2TXRQTirOpL9Aock3cS4YzpIiCT7PqsbeBbOkD+d8ue
         iCQOARBiIB0U3XQhnRjalX/8syDgeUaT06F4aKA15k//zR/Owbng7cnEdb7Q3U/f10HK
         BSuamdOXVJl3MZNxbBUfoyNbpdS4+amci/pSFqJVU048X8FT12iv44bIOAWgWFN23HlS
         AGluBazGOrygvy0892zukucYeQVxBa7FCWWYT9ExxSkhfWjMD7y15hVkTUbpp6fqhZne
         ObAw==
X-Gm-Message-State: AAQBX9dCvU++V8cu/qCbJivdDB0GeC4Kdr9S2Rl8OYrQN2/t5yqzxIO3
        NUTBq0zN6kVkFXO80jtSy7dFBg+9j1Driw==
X-Google-Smtp-Source: AKy350YlZB/ldHtjCn47nsH4xFOYG7SnmkwinOPLkSjCIrfKl9AfkEQ3T56sr31pDs7AwX4FfNvLNw==
X-Received: by 2002:a17:902:e5c8:b0:1a1:e112:461c with SMTP id u8-20020a170902e5c800b001a1e112461cmr10648719plf.30.1680267262618;
        Fri, 31 Mar 2023 05:54:22 -0700 (PDT)
Received: from debian.me (subs10b-223-255-225-236.three.co.id. [223.255.225.236])
        by smtp.gmail.com with ESMTPSA id t6-20020a170902bc4600b0019ab151eb90sm1500386plz.139.2023.03.31.05.54.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Mar 2023 05:54:22 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 23D56106767; Fri, 31 Mar 2023 19:54:17 +0700 (WIB)
Date:   Fri, 31 Mar 2023 19:54:17 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Ilari =?utf-8?B?SsOkw6Rza2Vsw6RpbmVu?= 
        <ijaaskelainen@outlook.com>, Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
Message-ID: <ZCbX+Us9BqGooeXi@debian.me>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
 <ZCaULkVk6iHHJYm2@kroah.com>
 <GV1PR10MB6241B5ACB73021007421876DA38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="JvjEdR6ADcxhKZM2"
Content-Disposition: inline
In-Reply-To: <GV1PR10MB6241B5ACB73021007421876DA38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--JvjEdR6ADcxhKZM2
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 31, 2023 at 12:52:37PM +0300, Ilari J=C3=A4=C3=A4skel=C3=A4inen=
 wrote:
> Here is the output of dmesg without doing anything with the disk:
>=20
> [ 7632.544792] usb 2-2: new SuperSpeed USB device number 2 using
> xhci_hcd
> [ 7632.575851] usb 2-2: New USB device found, idVendor=3D152d,
> idProduct=3Db567, bcdDevice=3D 2.23
> [ 7632.575856] usb 2-2: New USB device strings: Mfr=3D1, Product=3D2,
> SerialNumber=3D3
> [ 7632.575858] usb 2-2: Product: USB3.0 to SATA adapter
> [ 7632.575860] usb 2-2: Manufacturer: JMicron
> [ 7632.575861] usb 2-2: SerialNumber: 0000AB123531
> [ 7632.636013] usbcore: registered new interface driver usb-storage
> [ 7632.655897] scsi host4: uas
> [ 7632.656277] usbcore: registered new interface driver uas
> [ 7632.656480] scsi 4:0:0:0: Direct-Access     Samsung  SSD 860 EVO
> 500G 0223 PQ: 0 ANSI: 6
> [ 7632.657492] sd 4:0:0:0: Attached scsi generic sg2 type 0
> [ 7632.657753] sd 4:0:0:0: [sdb] Spinning up disk...
> [ 7633.694677] ...ready
> [ 7635.775548] sd 4:0:0:0: [sdb] 976773168 512-byte logical blocks:
> (500 GB/466 GiB)
> [ 7635.775551] sd 4:0:0:0: [sdb] 4096-byte physical blocks
> [ 7635.775707] sd 4:0:0:0: [sdb] Write Protect is off
> [ 7635.775710] sd 4:0:0:0: [sdb] Mode Sense: 53 00 00 08
> [ 7635.776003] sd 4:0:0:0: [sdb] Write cache: enabled, read cache:
> enabled, doesn't support DPO or FUA
> [ 7635.776308] sd 4:0:0:0: [sdb] Optimal transfer size 33553920 bytes
> not a multiple of physical block size (4096 bytes)
> [ 7635.783827]  sdb: sdb1
> [ 7635.786814] sd 4:0:0:0: [sdb] Attached SCSI disk
> [ 7636.072316] EXT4-fs (sdb1): mounting ext2 file system using the ext4
> subsystem
> [ 7636.076261] EXT4-fs (sdb1): warning: mounting unchecked fs, running
> e2fsck is recommended
> [ 7636.083896] EXT4-fs (sdb1): mounted filesystem without journal.
> Opts: errors=3Dremount-ro. Quota mode: none.

Smells like nothing odd above, right?

--=20
An old man doll... just what I always wanted! - Clara

--JvjEdR6ADcxhKZM2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZCbX+QAKCRD2uYlJVVFO
o9aoAP0TUNKqRQtAYVewlj9HmNosJh039lcnwusdyC+d8c3AgwEAkRabYZFrAawi
WtYPltb0OuHNqgXQEdfFLh65bf11RAc=
=ab83
-----END PGP SIGNATURE-----

--JvjEdR6ADcxhKZM2--
