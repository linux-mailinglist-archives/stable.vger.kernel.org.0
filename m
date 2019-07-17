Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FDEE6B4DF
	for <lists+stable@lfdr.de>; Wed, 17 Jul 2019 05:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbfGQDH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jul 2019 23:07:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56034 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbfGQDH7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jul 2019 23:07:59 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id C64C4307CDE7;
        Wed, 17 Jul 2019 03:07:58 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B7A4E5C28C;
        Wed, 17 Jul 2019 03:07:58 +0000 (UTC)
Received: from zmail25.collab.prod.int.phx2.redhat.com (zmail25.collab.prod.int.phx2.redhat.com [10.5.83.31])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id AB1E11800202;
        Wed, 17 Jul 2019 03:07:58 +0000 (UTC)
Date:   Tue, 16 Jul 2019 23:07:58 -0400 (EDT)
From:   Ronnie Sahlberg <lsahlber@redhat.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-cifs <linux-cifs@vger.kernel.org>,
        Steve French <smfrench@gmail.com>,
        Stable <stable@vger.kernel.org>
Message-ID: <35870027.497391.1563332878632.JavaMail.zimbra@redhat.com>
In-Reply-To: <20190716012711.884162173B@mail.kernel.org>
References: <20190716004146.13668-1-lsahlber@redhat.com> <20190716012711.884162173B@mail.kernel.org>
Subject: Re: [PATCH] cifs: fix crash in
 smb2_compound_op()/smb2_set_next_command()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.64.54.77, 10.4.195.25]
Thread-Topic: cifs: fix crash in smb2_compound_op()/smb2_set_next_command()
Thread-Index: gzHCbTgXc3e2JjoTxl/A8nKryX+WaQ==
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.49]); Wed, 17 Jul 2019 03:07:58 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org





----- Original Message -----
> From: "Sasha Levin" <sashal@kernel.org>
> To: "Sasha Levin" <sashal@kernel.org>, "Ronnie Sahlberg" <lsahlber@redhat.com>, "linux-cifs"
> <linux-cifs@vger.kernel.org>
> Cc: "Steve French" <smfrench@gmail.com>, "Stable" <stable@vger.kernel.org>, stable@vger.kernel.org
> Sent: Tuesday, 16 July, 2019 11:27:10 AM
> Subject: Re: [PATCH] cifs: fix crash in smb2_compound_op()/smb2_set_next_command()
> 
> Hi,
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a -stable tag.
> The stable tag indicates that it's relevant for the following trees: all
> 
> The bot has tested the following trees: v5.2.1, v5.1.18, v4.19.59, v4.14.133,
> v4.9.185, v4.4.185.
> 
> v5.2.1: Build OK!
> v5.1.18: Build OK!
> v4.19.59: Failed to apply! Possible dependencies:
>     271b9c0c8007 ("smb3: Fix rmdir compounding regression to strict servers")
>     c2e0fe3f5aae ("cifs: make rmdir() use compounding")
>     c5a5f38f075c ("cifs: add a smb2_compound_op and change QUERY_INFO to use
>     it")
>     dcbf91035709 ("cifs: change SMB2_OP_SET_INFO to use compounding")
>     e77fe73c7e38 ("cifs: we can not use small padding iovs together with
>     encryption")
>     f5b05d622a3e ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
>     f733e3936da4 ("cifs: change mkdir to use a compound")
>     f7bfe04bf0db ("cifs: change SMB2_OP_SET_EOF to use compounding")
> 
> v4.14.133: Failed to apply! Possible dependencies:
>     2e96467d9eb1 ("cifs: add pdu_size to the TCP_Server_Info structure")
>     3d4ef9a15343 ("smb3: fix redundant opens on root")
>     730928c8f4be ("cifs: update smb2_queryfs() to use compounding")
>     74dcf418fe34 ("CIFS: SMBD: Read correct returned data length for RDMA
>     write (SMB read) I/O")
>     8ce79ec359ad ("cifs: update multiplex loop to handle compounded
>     responses")
>     91cb74f5142c ("cifs: Change SMB2_open to return an iov for the error
>     parameter")
>     93012bf98416 ("cifs: add server->vals->header_preamble_size")
>     9d874c36552a ("cifs: fix a buffer leak in smb2_query_symlink")
>     c5a5f38f075c ("cifs: add a smb2_compound_op and change QUERY_INFO to use
>     it")
>     f5b05d622a3e ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
> 
> v4.9.185: Failed to apply! Possible dependencies:
>     31473fc4f965 ("CIFS: Separate SMB2 header structure")
>     7fb8986e7449 ("CIFS: Add capability to transform requests before
>     sending")
>     8ce79ec359ad ("cifs: update multiplex loop to handle compounded
>     responses")
>     9bb17e0916a0 ("CIFS: Add transform header handling callbacks")
>     b8f57ee8aad4 ("CIFS: Separate RFC1001 length processing for SMB2 read")
>     da502f7df03d ("CIFS: Make SendReceive2() takes resp iov")
>     ef65aaede23f ("smb2: Enforce sec= mount option")
>     f5b05d622a3e ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
> 
> v4.4.185: Failed to apply! Possible dependencies:
>     141891f4727c ("SMB3: Add mount parameter to allow user to override max
>     credits")
>     166cea4dc3a4 ("SMB2: Separate RawNTLMSSP authentication from
>     SMB2_sess_setup")
>     16c568efff82 ("cifs: merge the hash calculation helpers")
>     275516cdcfa4 ("Print IP address of unresponsive server")
>     31473fc4f965 ("CIFS: Separate SMB2 header structure")
>     373512ec5c10 ("Prepare for encryption support (first part). Add
>     decryption and encryption key generation. Thanks to Metze for helping
>     with this.")
>     3baf1a7b9215 ("SMB2: Separate Kerberos authentication from
>     SMB2_sess_setup")
>     7fb8986e7449 ("CIFS: Add capability to transform requests before
>     sending")
>     834170c85978 ("Enable previous version support")
>     8ce79ec359ad ("cifs: update multiplex loop to handle compounded
>     responses")
>     9bb17e0916a0 ("CIFS: Add transform header handling callbacks")
>     adfeb3e00e8e ("cifs: Make echo interval tunable")
>     da502f7df03d ("CIFS: Make SendReceive2() takes resp iov")
>     ef65aaede23f ("smb2: Enforce sec= mount option")
>     f5b05d622a3e ("cifs: add IOCTL for QUERY_INFO passthrough to userspace")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

So it applies cleanly in  v5.2.1 and v5.1.18.
I think it is sufficient to get into those two versions then.  It is very hard to trigger this issue.


> --
> Thanks,
> Sasha
> 
