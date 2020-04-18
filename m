Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7231E1AEA40
	for <lists+stable@lfdr.de>; Sat, 18 Apr 2020 08:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgDRGnd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Apr 2020 02:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgDRGnc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Apr 2020 02:43:32 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6774C061A0C
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 23:43:32 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id d17so2258770pgo.0
        for <stable@vger.kernel.org>; Fri, 17 Apr 2020 23:43:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=b5/8s4WjgnJ9BJ3t8NL65J5PnueoPCCrcsfXQFE5N5A=;
        b=I276jLUPOtVz+O749sDVzZ75n1/QMKuY788aaK2tg6tOd/l7+ioo54rOIWpmnJf7sJ
         7npVhPRYtJi+oxWHZ/a5sruUdIoig/xd07CJjm78RhuB6q+sBkE/XvWme1ne1HtYL5jS
         3hkKXc7obz0m2ExJBq1fpd7WMRv1VhXj4wweNgV+5jwzsRMYQvzATworDegKJNo2sCwE
         2yYubNuJiPZerGMYX/igyYXjifqhp/+oKq+2PQt++JGzQDPo0iE+AUEKm0ScKz9p3jE6
         SMJrzYlhPqgjgXRqm1a3Ig3YGi1rbtyipB2ncbvXRkNzhNd/zUbDBRdBZZXPnQ0a+61F
         PZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=b5/8s4WjgnJ9BJ3t8NL65J5PnueoPCCrcsfXQFE5N5A=;
        b=X6lr+8X2I2BFBCY9lsAZLlKqeg6Z1Y2i97TU+n29iRn05kBlNFzENPk34rCiSSOTUS
         rFde1bDQ4RXAe1LECdjfKES8MBu3dDUBmiRbtbcASh501amYmPO7KjBpc8QCrExVcnNI
         JSJlUxy5YI645k4wZZXBZtf4lm9Vkjtw202XJQj587i+63j/DSp70pByolorImeiHHqN
         VvOcoSpYCKo5Rgv0xSeV/jT5QsqjxQ9dTJn7mJT4/C8hSO/m4Paf2yvyYKC/vJCJdZap
         8mZq5yC28FB1eups6oqh9jkV9HhK2p+/cJcZ+z1Xf9SAT536QzIRK1zomUdX7WfBQpep
         PbBw==
X-Gm-Message-State: AGi0PuYTzMz6MWhM4aPz6A2L5LnG78c5RmMSJi8KWrk8Z4JNeCn1x85o
        SPgCaVFZg91WV89P2SX2GgY=
X-Google-Smtp-Source: APiQypLPC1zcodSLSds+MLuVBAhTF1TpqjPxqCv+amv8jPDuctnVVNA6p/wQHMuLE/dgn/+uyLMhcA==
X-Received: by 2002:a63:cd03:: with SMTP id i3mr6353982pgg.395.1587192212225;
        Fri, 17 Apr 2020 23:43:32 -0700 (PDT)
Received: from localhost ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id e29sm16214499pgn.57.2020.04.17.23.43.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2020 23:43:31 -0700 (PDT)
Date:   Sat, 18 Apr 2020 14:43:23 +0800
From:   Murphy Zhou <jencce.kernel@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     jencce.kernel@gmail.com, lsahlber@redhat.com,
        stable@vger.kernel.org, stfrench@microsoft.com
Subject: Re: FAILED: patch "[PATCH] CIFS: check new file size when extending
 file by fallocate" failed to apply to 5.4-stable tree
Message-ID: <20200418064323.zbcleoq2inktdhyd@xzhoux.usersys.redhat.com>
References: <15868733793359@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <15868733793359@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 04:09:39PM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

It depends on other commits which does not suit stable, so skip this
patch on stable trees that does not apply cleanly.

Thanks!

> 
> thanks,
> 
> greg k-h
> 
> ------------------ original commit in Linus's tree ------------------
> 
> From ef4a632ccc1c7d3fb71a5baae85b79af08b7f94b Mon Sep 17 00:00:00 2001
> From: Murphy Zhou <jencce.kernel@gmail.com>
> Date: Wed, 18 Mar 2020 20:43:38 +0800
> Subject: [PATCH] CIFS: check new file size when extending file by fallocate
> 
> xfstests generic/228 checks if fallocate respect RLIMIT_FSIZE.
> After fallocate mode 0 extending enabled, we can hit this failure.
> Fix this by check the new file size with vfs helper, return
> error if file size is larger then RLIMIT_FSIZE(ulimit -f).
> 
> This patch has been tested by LTP/xfstests aginst samba and
> Windows server.
> 
> Acked-by: Ronnie Sahlberg <lsahlber@redhat.com>
> Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
> Signed-off-by: Steve French <stfrench@microsoft.com>
> CC: Stable <stable@vger.kernel.org>
> 
> diff --git a/fs/cifs/smb2ops.c b/fs/cifs/smb2ops.c
> index b0759c8aa6f5..9c9258fc8756 100644
> --- a/fs/cifs/smb2ops.c
> +++ b/fs/cifs/smb2ops.c
> @@ -3255,6 +3255,10 @@ static long smb3_simple_falloc(struct file *file, struct cifs_tcon *tcon,
>  	 * Extending the file
>  	 */
>  	if ((keep_size == false) && i_size_read(inode) < off + len) {
> +		rc = inode_newsize_ok(inode, off + len);
> +		if (rc)
> +			goto out;
> +
>  		if ((cifsi->cifsAttrs & FILE_ATTRIBUTE_SPARSE_FILE) == 0)
>  			smb2_set_sparse(xid, tcon, cfile, inode, false);
>  
> 

-- 
Murphy
