Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABF11355724
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 17:01:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242371AbhDFPB2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 11:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbhDFPB2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 11:01:28 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C697C06174A;
        Tue,  6 Apr 2021 08:01:18 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dd20so9757238edb.12;
        Tue, 06 Apr 2021 08:01:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iQ912Wkwl3nWfqvXsVel2XU5+3g8TUt/hbvwzAd8qXQ=;
        b=XJ9S5wR9Y0TACv70W2WdKlX/DKrYRHeaqlejtzIqjOi8Sn6PannNU2OK7VxgD5yhxB
         8zWvDda3tY0JtdZ2YgznlycYIxWGhJaXcDfkCotADMjiVTkCh/9ZT4GjsixhxfhQVZNR
         9GjloK7xJdz6SH8eOETpioltuqtCGAjQXv9buU0bTNVwOv0/s9Fcn08Ivp5uQDu3lHOE
         d/+WFRaESM2suaGmIfAlfPqcYJ5t+WUIkvHyb75sZuAzkFoC2Q7iN2h+cIZyYatqN90H
         7RnQF1MLvWpibYuT5ES4G1hi6vhHiarFVPtNCwnt3KLQt92lO2sFfawS0qSHo8F0YMbI
         5RiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=iQ912Wkwl3nWfqvXsVel2XU5+3g8TUt/hbvwzAd8qXQ=;
        b=mDolfsuRaMLF62y/JBNg5NIh/yuvhfEwFWgkavMYCQqzXJYf3VZXo2Iqlfhy112BFu
         ww5hkvGRc1J6lABRR31aodTnCgHskHDknujC7BEa1VJnN49LggAdG9+ce26iGWUchktM
         vhE8C/6h118Y3EkagjGKCD9cfcJ8263A1L3B0k0n9rzIOy+6SxjL8msb76LFR3fUYE5t
         mZERaYKi36ftdhC/yG9TyLchkIYOvh8oBYf5Qc3t60EVCaxSAgpGi1z+A9OiOzTorbVv
         v6srs9EzPSFXl4K6o10WU9y3euiTUo+kmDfXg0UECO2Ze44ca+mfX4GpsJfxv9kNIluE
         8IOw==
X-Gm-Message-State: AOAM532v9OPq3IkNt1aGs70cT+bSbqXltNpbSQJ0+seCIG8i2g2QjTa2
        BzLXf+JBBoAhckMq6+yL90k=
X-Google-Smtp-Source: ABdhPJwaXNQ/JmB0yVLVKSgpJ1qbhy6ICfUIj0I6Ws4bs9KkBx6s6tvoYhvR20T8JpRVoDcx9WhYqA==
X-Received: by 2002:a05:6402:34cd:: with SMTP id w13mr6334730edc.73.1617721277181;
        Tue, 06 Apr 2021 08:01:17 -0700 (PDT)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id o6sm13634573edw.24.2021.04.06.08.01.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 08:01:15 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Date:   Tue, 6 Apr 2021 17:01:15 +0200
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Shyam Prasad <Shyam.Prasad@microsoft.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Aurelien Aptel <aaptel@suse.com>,
        Steven French <Steven.French@microsoft.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH 4.19 013/247] cifs: Set
 CIFS_MOUNT_USE_PREFIX_PATH flag on setting cifs_sb->prepath.
Message-ID: <YGx3u01Wa/DDnjlV@eldamar.lan>
References: <20210301161031.684018251@linuxfoundation.org>
 <20210301161032.337414143@linuxfoundation.org>
 <YGxIMCsclG4E1/ck@eldamar.lan>
 <YGxlJXv/+IPaErUr@kroah.com>
 <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8+rZL4rJ0lzO3si"
Content-Disposition: inline
In-Reply-To: <PSAP153MB04220682838AC9D025414B6094769@PSAP153MB0422.APCP153.PROD.OUTLOOK.COM>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--a8+rZL4rJ0lzO3si
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Tue, Apr 06, 2021 at 02:00:48PM +0000, Shyam Prasad wrote:
> Hi Greg,
> We'll need to debug this further to understand what's going on. 

Greg asked it the same happens with 5.4 as well, I do not know I was
not able to test 5.4.y (yet) but only 5.10.y and 4.19.y.
> 
> Hi Salvatore,
> Any chance that you'll be able to provide us the cifsFYI logs from the time of mount failure?
> https://wiki.samba.org/index.php/LinuxCIFS_troubleshooting#Enabling_Debugging

Please find it attached. Is this enough information?

The mentioned home DFS link 'home' is a DFS link to
msdfs:SECONDHOST\REDACTED on a Samba host.

The mount is triggered as

mount -t cifs //HOSTIP/REDACTED/home /mnt --verbose -o username='REDACTED,domain=DOMAIN'

Regards,
Salvatore

--a8+rZL4rJ0lzO3si
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.log"

[  514.926988] fs/cifs/cifsfs.c: Devname: //HOSTIP/REDACTED/home flags: 0
[  514.927034] fs/cifs/connect.c: Domain name set
[  514.927045] No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
[  514.938086] fs/cifs/connect.c: Username: REDACTED
[  514.938227] fs/cifs/connect.c: file mode: 0755  dir mode: 0755
[  514.938229] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 22 with uid: 0
[  514.938230] fs/cifs/connect.c: UNC: \\HOSTIP\REDACTED
[  514.938242] fs/cifs/connect.c: Socket created
[  514.938244] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[  514.938740] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x00000000d2679e7e/0x00000000684ecea8)
[  514.938743] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 23 with uid: 0
[  514.938744] fs/cifs/connect.c: Existing smb sess not found
[  514.938747] fs/cifs/smb2pdu.c: Negotiate protocol
[  514.938756] fs/cifs/transport.c: Sending smb: smb_len=110
[  514.938783] fs/cifs/connect.c: Demultiplex PID: 708
[  514.975155] fs/cifs/connect.c: RFC1002 header 0xe0
[  514.975161] fs/cifs/smb2misc.c: SMB2 data length 96 offset 128
[  514.975161] fs/cifs/smb2misc.c: SMB2 len 224
[  514.975195] fs/cifs/transport.c: cifs_sync_mid_result: cmd=0 mid=0 state=4
[  514.975202] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  514.975204] fs/cifs/smb2pdu.c: mode 0x1
[  514.975205] fs/cifs/smb2pdu.c: negotiated smb3.02 dialect
[  514.975209] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
[  514.975210] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
[  514.975211] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[  514.975212] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300047 TimeAdjust: 0
[  514.975213] fs/cifs/smb2pdu.c: Session Setup
[  514.975214] fs/cifs/smb2pdu.c: sess setup type 4
[  514.975220] fs/cifs/transport.c: Sending smb: smb_len=124
[  514.989895] fs/cifs/connect.c: RFC1002 header 0xe6
[  514.989899] fs/cifs/smb2misc.c: SMB2 data length 158 offset 72
[  514.989900] fs/cifs/smb2misc.c: SMB2 len 230
[  514.989922] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=1 state=4
[  514.989933] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
[  514.992502] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000016 to POSIX err -5
[  514.992618] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  514.992622] fs/cifs/smb2pdu.c: rawntlmssp session setup challenge phase
[  514.992664] fs/cifs/transport.c: Sending smb: smb_len=336
[  515.216303] fs/cifs/connect.c: RFC1002 header 0x48
[  515.216312] fs/cifs/smb2misc.c: SMB2 data length 0 offset 72
[  515.216313] fs/cifs/smb2misc.c: SMB2 len 73
[  515.216316] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 2
[  515.216352] fs/cifs/transport.c: cifs_sync_mid_result: cmd=1 mid=2 state=4
[  515.216356] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.216380] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
[  515.216384] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 23) rc = 0
[  515.216389] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 24 with uid: 0
[  515.216391] fs/cifs/smb2pdu.c: TCON
[  515.216403] fs/cifs/transport.c: Sending smb: smb_len=116
[  515.231610] fs/cifs/connect.c: RFC1002 header 0x50
[  515.231618] fs/cifs/smb2misc.c: SMB2 len 80
[  515.231656] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=3 state=4
[  515.231658] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.231661] fs/cifs/smb2ops.c: add 2 credits total=34
[  515.231663] fs/cifs/smb2pdu.c: connection to pipe share
[  515.231665] fs/cifs/smb2pdu.c: validate negotiate
[  515.231667] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.231687] fs/cifs/transport.c: Sending smb: smb_len=154
[  515.246340] fs/cifs/connect.c: RFC1002 header 0x88
[  515.246348] fs/cifs/smb2misc.c: SMB2 data length 24 offset 112
[  515.246349] fs/cifs/smb2misc.c: SMB2 len 136
[  515.246364] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=4 state=4
[  515.246366] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.246368] fs/cifs/smb2ops.c: add 2 credits total=35
[  515.246371] fs/cifs/smb2pdu.c: validate negotiate info successful
[  515.246374] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 24) rc = 0
[  515.246375] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 26334402
[  515.246381] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 25 with uid: 0
[  515.246382] fs/cifs/smb2pdu.c: TCON
[  515.246393] fs/cifs/transport.c: Sending smb: smb_len=124
[  515.261403] fs/cifs/connect.c: RFC1002 header 0x50
[  515.261411] fs/cifs/smb2misc.c: SMB2 len 80
[  515.261425] fs/cifs/transport.c: cifs_sync_mid_result: cmd=3 mid=5 state=4
[  515.261427] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.261429] fs/cifs/smb2ops.c: add 2 credits total=36
[  515.261431] fs/cifs/smb2pdu.c: connection to disk share
[  515.261433] fs/cifs/smb2pdu.c: validate negotiate
[  515.261434] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.261450] fs/cifs/transport.c: Sending smb: smb_len=154
[  515.276126] fs/cifs/connect.c: RFC1002 header 0x88
[  515.276133] fs/cifs/smb2misc.c: SMB2 data length 24 offset 112
[  515.276134] fs/cifs/smb2misc.c: SMB2 len 136
[  515.276149] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=6 state=4
[  515.276150] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.276153] fs/cifs/smb2ops.c: add 2 credits total=37
[  515.276155] fs/cifs/smb2pdu.c: validate negotiate info successful
[  515.276158] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 25) rc = 0
[  515.276159] fs/cifs/connect.c: Tcon rc = 0
[  515.276165] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x00000000684ecea8/0x000000004ef56176)
[  515.276167] fs/cifs/smb2pdu.c: create/open
[  515.276180] fs/cifs/transport.c: Sending smb: smb_len=252
[  515.291695] fs/cifs/connect.c: RFC1002 header 0x98
[  515.291703] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[  515.291705] fs/cifs/smb2misc.c: SMB2 len 153
[  515.291707] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 7
[  515.291721] fs/cifs/transport.c: cifs_sync_mid_result: cmd=5 mid=7 state=4
[  515.291723] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.291725] fs/cifs/smb2ops.c: add 2 credits total=38
[  515.291728] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.291739] fs/cifs/transport.c: Sending smb: smb_len=125
[  515.306208] fs/cifs/connect.c: RFC1002 header 0x49
[  515.306215] fs/cifs/smb2misc.c: SMB2 data length 0 offset 0
[  515.306217] fs/cifs/smb2misc.c: SMB2 len 73
[  515.306231] fs/cifs/transport.c: cifs_sync_mid_result: cmd=11 mid=8 state=4
[  515.306235] Status code returned 0xc0000010 STATUS_INVALID_DEVICE_REQUEST
[  515.312000] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000010 to POSIX err -95
[  515.312003] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.312007] fs/cifs/smb2ops.c: add 2 credits total=39
[  515.312010] fs/cifs/smb2ops.c: server does not support query network interfaces
[  515.312012] fs/cifs/smb2pdu.c: Query FSInfo level 5
[  515.312876] fs/cifs/transport.c: Sending smb: smb_len=109
[  515.327423] fs/cifs/connect.c: RFC1002 header 0x5c
[  515.327429] fs/cifs/smb2misc.c: SMB2 data length 20 offset 72
[  515.327431] fs/cifs/smb2misc.c: SMB2 len 92
[  515.327445] fs/cifs/transport.c: cifs_sync_mid_result: cmd=16 mid=9 state=4
[  515.327446] fs/cifs/misc.c: Null buffer passed to cifs_small_buf_release
[  515.327448] fs/cifs/smb2ops.c: add 2 credits total=40
[  515.327451] fs/cifs/smb2pdu.c: Query FSInfo level 4
[  515.341970] fs/cifs/smb2misc.c: SMB2 data length 8 offset 72
[  515.341989] fs/cifs/smb2ops.c: add 2 credits total=41
[  515.341991] fs/cifs/smb2pdu.c: Query FSInfo level 1
[  515.356797] fs/cifs/smb2misc.c: SMB2 data length 34 offset 72
[  515.356815] fs/cifs/smb2ops.c: add 2 credits total=42
[  515.356818] fs/cifs/smb2pdu.c: Query FSInfo level 11
[  515.371694] fs/cifs/smb2ops.c: add 2 credits total=43
[  515.371701] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\HOSTIP\REDACTED\home
[  515.371704] fs/cifs/smb2ops.c: smb2_get_dfs_refer path <\HOSTIP\REDACTED>
[  515.371709] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.386939] fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x3 ...
[  515.386955] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: unc is IP, skipping dns upcall: HOSTIP
[  515.386979] fs/cifs/connect.c: Domain name set
[  515.386990] No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
[  515.400089] fs/cifs/connect.c: Username: REDACTED
[  515.400091] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[  515.400091] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 26 with uid: 0
[  515.400092] fs/cifs/smb2pdu.c: Tree Disconnect
[  515.414824] fs/cifs/fscache.c: cifs_fscache_release_super_cookie: (0x000000004ef56176)
[  515.414826] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[  515.414827] fs/cifs/connect.c: CIFS VFS: in cifs_free_ipc as Xid: 27 with uid: 0
[  515.414827] fs/cifs/smb2pdu.c: Tree Disconnect
[  515.414828] fs/cifs/connect.c: CIFS VFS: leaving cifs_free_ipc (xid = 27) rc = -5
[  515.414828] fs/cifs/connect.c: failed to disconnect IPC tcon (rc=-5)
[  515.414829] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 28 with uid: 0
[  515.414830] fs/cifs/smb2pdu.c: disconnect session 000000006ca91b5c
[  515.429202] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0x00000000d2679e7e/0x00000000684ecea8)
[  515.429209] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 22) rc = 0
[  515.429210] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 29 with uid: 0
[  515.429211] fs/cifs/connect.c: UNC: \\HOSTIP\REDACTED
[  515.429230] fs/cifs/connect.c: Socket created
[  515.429232] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[  515.429597] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x00000000462d8926/0x000000004ef56176)
[  515.429608] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 30 with uid: 0
[  515.429609] fs/cifs/connect.c: Existing smb sess not found
[  515.429676] fs/cifs/smb2pdu.c: Negotiate protocol
[  515.429726] fs/cifs/connect.c: Demultiplex PID: 709
[  515.466950] fs/cifs/smb2pdu.c: mode 0x1
[  515.466952] fs/cifs/smb2pdu.c: negotiated smb3.02 dialect
[  515.466956] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
[  515.466957] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
[  515.466958] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[  515.466960] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300047 TimeAdjust: 0
[  515.466961] fs/cifs/smb2pdu.c: Session Setup
[  515.466962] fs/cifs/smb2pdu.c: sess setup type 4
[  515.481545] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
[  515.484947] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000016 to POSIX err -5
[  515.484952] fs/cifs/smb2pdu.c: rawntlmssp session setup challenge phase
[  515.607137] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 2
[  515.607171] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
[  515.607175] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 30) rc = 0
[  515.607179] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 31 with uid: 0
[  515.607181] fs/cifs/smb2pdu.c: TCON
[  515.622244] fs/cifs/smb2pdu.c: connection to pipe share
[  515.622247] fs/cifs/smb2pdu.c: validate negotiate
[  515.622250] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.637047] fs/cifs/smb2pdu.c: validate negotiate info successful
[  515.637052] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 31) rc = 0
[  515.637054] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = 211309129
[  515.637059] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 32 with uid: 0
[  515.637060] fs/cifs/smb2pdu.c: TCON
[  515.652585] fs/cifs/smb2pdu.c: connection to disk share
[  515.652588] fs/cifs/smb2pdu.c: validate negotiate
[  515.652590] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.667482] fs/cifs/smb2pdu.c: validate negotiate info successful
[  515.667487] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 32) rc = 0
[  515.667488] fs/cifs/connect.c: Tcon rc = 0
[  515.667495] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x000000004ef56176/0x00000000f43276d2)
[  515.667497] fs/cifs/smb2pdu.c: create/open
[  515.682771] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 7
[  515.682796] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.697266] Status code returned 0xc0000010 STATUS_INVALID_DEVICE_REQUEST
[  515.702597] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000010 to POSIX err -95
[  515.702604] fs/cifs/smb2ops.c: server does not support query network interfaces
[  515.702607] fs/cifs/smb2pdu.c: Query FSInfo level 5
[  515.717126] fs/cifs/smb2pdu.c: Query FSInfo level 4
[  515.731626] fs/cifs/smb2pdu.c: Query FSInfo level 1
[  515.746342] fs/cifs/smb2pdu.c: Query FSInfo level 11
[  515.761307] fs/cifs/smb2pdu.c: create/open
[  515.776111] Status code returned 0xc0000257 STATUS_PATH_NOT_COVERED
[  515.780819] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000257 to POSIX err -66
[  515.780828] fs/cifs/connect.c: build_unc_path_to_root: full_path=\\HOSTIP\REDACTED\home
[  515.780830] fs/cifs/smb2ops.c: smb2_get_dfs_refer path <\HOSTIP\REDACTED\home>
[  515.780836] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  515.795585] fs/cifs/misc.c: num_referrals: 1 dfs flags: 0x2 ...
[  515.795598] fs/cifs/dns_resolve.c: dns_resolve_server_name_to_ip: resolved: SECONDHOST to SECONDHOSTIP
[  515.795611] fs/cifs/connect.c: Domain name set
[  515.795617] No dialect specified on mount. Default has changed to a more secure dialect, SMB2.1 or later (e.g. SMB3), from CIFS (SMB1). To use the less secure SMB1 dialect to access old servers which do not support SMB3 (or SMB2.1) specify vers=1.0 on mount.
[  515.803897] fs/cifs/connect.c: Username: REDACTED
[  515.803900] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[  515.803901] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 33 with uid: 0
[  515.803902] fs/cifs/smb2pdu.c: Tree Disconnect
[  515.818981] fs/cifs/fscache.c: cifs_fscache_release_super_cookie: (0x00000000f43276d2)
[  515.818985] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[  515.818987] fs/cifs/connect.c: CIFS VFS: in cifs_free_ipc as Xid: 34 with uid: 0
[  515.818988] fs/cifs/smb2pdu.c: Tree Disconnect
[  515.818989] fs/cifs/connect.c: CIFS VFS: leaving cifs_free_ipc (xid = 34) rc = -5
[  515.818990] fs/cifs/connect.c: failed to disconnect IPC tcon (rc=-5)
[  515.818991] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 35 with uid: 0
[  515.818992] fs/cifs/smb2pdu.c: disconnect session 00000000490c2b16
[  515.834179] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0x00000000462d8926/0x000000004ef56176)
[  515.834188] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 29) rc = 0
[  515.834190] fs/cifs/connect.c: CIFS VFS: in cifs_mount as Xid: 36 with uid: 0
[  515.834191] fs/cifs/connect.c: UNC: \\SECONDHOST\REDACTED
[  515.834210] fs/cifs/connect.c: Socket created
[  515.834212] fs/cifs/connect.c: sndbuf 16384 rcvbuf 131072 rcvtimeo 0x6d6
[  515.834653] fs/cifs/fscache.c: cifs_fscache_get_client_cookie: (0x000000000856a885/0x000000004ef56176)
[  515.834657] fs/cifs/connect.c: CIFS VFS: in cifs_get_smb_ses as Xid: 37 with uid: 0
[  515.834658] fs/cifs/connect.c: Existing smb sess not found
[  515.834661] fs/cifs/smb2pdu.c: Negotiate protocol
[  515.834732] fs/cifs/connect.c: Demultiplex PID: 710
[  515.905007] fs/cifs/smb2pdu.c: mode 0x1
[  515.905009] fs/cifs/smb2pdu.c: negotiated smb3.02 dialect
[  515.905013] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0xbb92
[  515.905015] fs/cifs/asn1.c: OID len = 7 oid = 0x1 0x2 0x348 0x1bb92
[  515.905016] fs/cifs/asn1.c: OID len = 10 oid = 0x1 0x3 0x6 0x1
[  515.905019] fs/cifs/connect.c: Security Mode: 0x1 Capabilities: 0x300047 TimeAdjust: 0
[  515.905019] fs/cifs/smb2pdu.c: Session Setup
[  515.905021] fs/cifs/smb2pdu.c: sess setup type 4
[  515.919817] Status code returned 0xc0000016 STATUS_MORE_PROCESSING_REQUIRED
[  515.923917] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000016 to POSIX err -5
[  515.923924] fs/cifs/smb2pdu.c: rawntlmssp session setup challenge phase
[  516.041427] fs/cifs/smb2misc.c: Calculated size 73 length 72 mismatch mid 2
[  516.041540] fs/cifs/smb2pdu.c: SMB2/3 session established successfully
[  516.041546] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_smb_ses (xid = 37) rc = 0
[  516.041551] fs/cifs/connect.c: CIFS VFS: in cifs_setup_ipc as Xid: 38 with uid: 0
[  516.041552] fs/cifs/smb2pdu.c: TCON
[  516.056722] fs/cifs/smb2pdu.c: connection to pipe share
[  516.056726] fs/cifs/smb2pdu.c: validate negotiate
[  516.056728] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  516.071737] fs/cifs/smb2pdu.c: validate negotiate info successful
[  516.071742] fs/cifs/connect.c: CIFS VFS: leaving cifs_setup_ipc (xid = 38) rc = 0
[  516.071743] fs/cifs/connect.c: IPC tcon rc = 0 ipc tid = -630022267
[  516.071749] fs/cifs/connect.c: CIFS VFS: in cifs_get_tcon as Xid: 39 with uid: 0
[  516.071750] fs/cifs/smb2pdu.c: TCON
[  516.087722] fs/cifs/smb2pdu.c: connection to disk share
[  516.087725] fs/cifs/smb2pdu.c: validate negotiate
[  516.087727] fs/cifs/smb2pdu.c: SMB2 IOCTL
[  516.101839] fs/cifs/smb2pdu.c: validate negotiate info successful
[  516.101844] fs/cifs/connect.c: CIFS VFS: leaving cifs_get_tcon (xid = 39) rc = 0
[  516.101846] fs/cifs/connect.c: Tcon rc = 0
[  516.101852] fs/cifs/fscache.c: cifs_fscache_get_super_cookie: (0x000000004ef56176/0x00000000f43276d2)
[  516.101854] fs/cifs/smb2pdu.c: create/open
[  516.116441] fs/cifs/smb2misc.c: Calculated size 153 length 152 mismatch mid 7
[  516.130609] Status code returned 0xc0000010 STATUS_INVALID_DEVICE_REQUEST
[  516.136197] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000010 to POSIX err -95
[  516.136205] fs/cifs/smb2ops.c: server does not support query network interfaces
[  516.136208] fs/cifs/smb2pdu.c: Query FSInfo level 5
[  516.150224] fs/cifs/smb2pdu.c: Query FSInfo level 4
[  516.192048] fs/cifs/connect.c: CIFS VFS: leaving cifs_mount (xid = 36) rc = 0
[  516.192194] fs/cifs/inode.c: CIFS VFS: in cifs_root_iget as Xid: 40 with uid: 0
[  516.192196] fs/cifs/inode.c: Getting info on \home
[  516.192220] fs/cifs/smb2pdu.c: create/open
[  516.207194] Status code returned 0xc0000034 STATUS_OBJECT_NAME_NOT_FOUND
[  516.211766] fs/cifs/smb2maperror.c: Mapping SMB2 status code 0xc0000034 to POSIX err -2
[  516.211776] fs/cifs/inode.c: CIFS VFS: leaving cifs_root_iget (xid = 40) rc = -2
[  516.211778] CIFS VFS: cifs_read_super: get root inode failed
[  516.216945] fs/cifs/connect.c: cifs_put_tcon: tc_count=1
[  516.216948] fs/cifs/connect.c: CIFS VFS: in cifs_put_tcon as Xid: 41 with uid: 0
[  516.216949] fs/cifs/smb2pdu.c: Tree Disconnect
[  516.231510] fs/cifs/fscache.c: cifs_fscache_release_super_cookie: (0x00000000f43276d2)
[  516.231513] fs/cifs/connect.c: cifs_put_smb_ses: ses_count=1
[  516.231514] fs/cifs/connect.c: CIFS VFS: in cifs_free_ipc as Xid: 42 with uid: 0
[  516.231514] fs/cifs/smb2pdu.c: Tree Disconnect
[  516.231515] fs/cifs/connect.c: CIFS VFS: leaving cifs_free_ipc (xid = 42) rc = -5
[  516.231516] fs/cifs/connect.c: failed to disconnect IPC tcon (rc=-5)
[  516.231516] fs/cifs/connect.c: CIFS VFS: in cifs_put_smb_ses as Xid: 43 with uid: 0
[  516.231517] fs/cifs/smb2pdu.c: disconnect session 00000000548ab32c
[  516.245329] fs/cifs/fscache.c: cifs_fscache_release_client_cookie: (0x000000000856a885/0x000000004ef56176)

--a8+rZL4rJ0lzO3si--
