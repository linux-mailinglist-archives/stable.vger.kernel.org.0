Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435295FBEF9
	for <lists+stable@lfdr.de>; Wed, 12 Oct 2022 03:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiJLBwL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 21:52:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbiJLBwC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 21:52:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E956DA4B93
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 18:52:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1665539519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/aoFTKs1+i/r1hVVhJXeOSGerK3qdHj+SZOhT30koZ8=;
        b=QpG2I5NKJq13jU3M7LDYQQTaBXQu1Tq0TqfHO7h7xXam9lhMIetdDCXhMHagmu6QtwtnbM
        wWBxd3Kk/NvAK0sBUMDyipiNEHizl3ewmtC7ljtxRY7wAOimh1knck2UZeFvObQoPHEOgn
        NWYupJmTHpHctc5/Oz2hJhGWy0tSQZw=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-378-HNHL_uEeP9CzQp0I7f1R7A-1; Tue, 11 Oct 2022 21:51:51 -0400
X-MC-Unique: HNHL_uEeP9CzQp0I7f1R7A-1
Received: by mail-pg1-f200.google.com with SMTP id k64-20020a638443000000b004620970e0dbso3721579pgd.6
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 18:51:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:content-transfer-encoding:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/aoFTKs1+i/r1hVVhJXeOSGerK3qdHj+SZOhT30koZ8=;
        b=gX++R9Ifkhjc3emlP5MY7jHdsk1S8tqKHmqRHhhApWyM/pskN90+5uzMD6cNqbgbSK
         23adIu6Qak1tKKmFAPSjsGL2wXXy/6z3OI4BSEVzfYW18qSPQQyA3I1i4aauSTorI7PI
         3bE+Oceag+5p3ZamLW8X1JaxvQ7RR/19wf8/HmJV9Xyxj75nmi3DShDXp4gTKpLLyDbV
         W4IrEZdDBzSjN5sMcfvdUIIER45LEr5afLjaHo3+HF1S6p1rsPeo/dDBmh1yD4oNALxE
         2jH6/r56lbNj1RlT5h2ytHtzJ6/JZ7rUlyX/prNuW0Tr20kMNFH5tTGNzd4GWdKS36sd
         BsoA==
X-Gm-Message-State: ACrzQf3ikIDUK+OuBjfzeet8u0u88DSaHMZXFzS7mPEdYtsckvwTbadn
        6l3k5tA9QBeFpy5wq/prul3ha2I3LE4Amhf6XnK4taiTIFVsvwVJl8iULenbDUbKhSqzcYQ0gFJ
        QsVHnmSW0l7OyqLI0b1e9pw8WYev3rPLJMUWNGUsSPY4EUiywZO3icAcENyA/7YZpVg==
X-Received: by 2002:a17:90b:2643:b0:205:bd0d:bdff with SMTP id pa3-20020a17090b264300b00205bd0dbdffmr2236861pjb.99.1665539509843;
        Tue, 11 Oct 2022 18:51:49 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4JbZ2tluRah5wFlLgizcV59zIqG1blSiKf601GHfEoTdxTNK/36+HeZsdsDSEnyyqZnLHXWg==
X-Received: by 2002:a17:90b:2643:b0:205:bd0d:bdff with SMTP id pa3-20020a17090b264300b00205bd0dbdffmr2236839pjb.99.1665539509410;
        Tue, 11 Oct 2022 18:51:49 -0700 (PDT)
Received: from [10.72.12.247] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id u187-20020a6279c4000000b0053725e331a1sm9682581pfc.82.2022.10.11.18.51.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 18:51:49 -0700 (PDT)
Subject: ceph: don't truncate file in atomic_open
To:     stable@vger.kernel.org
References: <59d7c10f-7419-971b-c13c-71865f897953@redhat.com>
 <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f87ea616-674b-2aad-f853-c28ea928ad4d@redhat.com>
Date:   Wed, 12 Oct 2022 09:51:43 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220701025227.21636-1-sehuww@mail.scut.edu.cn>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Maitainers

This patch is a fix in kceph module and should be backported to any 
affected stable old kernels. And the original patch missed tagging 
stable and got merged already months ago:

commit 7cb9994754f8a36ae9e5ec4597c5c4c2d6c03832
Author: Hu Weiwen <sehuww@mail.scut.edu.cn>
Date:   Fri Jul 1 10:52:27 2022 +0800

     ceph: don't truncate file in atomic_open

     Clear O_TRUNC from the flags sent in the MDS create request.

     `atomic_open' is called before permission check. We should not do any
     modification to the file here. The caller will do the truncation
     afterward.

     Fixes: 124e68e74099 ("ceph: file operations")
     Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
     Reviewed-by: Xiubo Li <xiubli@redhat.com>
     Signed-off-by: Ilya Dryomov <idryomov@gmail.com>


Just a single patch.

I am not very sure this is the correct way to do this, if anything else 
I need to do to backport this to old kernels please let me know.

Thanks!

- Xiubo



On 01/07/2022 10:52, Hu Weiwen wrote:
> Clear O_TRUNC from the flags sent in the MDS create request.
>
> `atomic_open' is called before permission check. We should not do any
> modification to the file here. The caller will do the truncation
> afterward.
>
> Fixes: 124e68e74099 ("ceph: file operations")
> Signed-off-by: Hu Weiwen <sehuww@mail.scut.edu.cn>
> ---
> rebased onto ceph_client repo testing branch
>
>   fs/ceph/file.c | 9 ++++++---
>   1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 296fd1c7ece8..289e66e9cbb0 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -745,6 +745,11 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	err = ceph_wait_on_conflict_unlink(dentry);
>   	if (err)
>   		return err;
> +	/*
> +	 * Do not truncate the file, since atomic_open is called before the
> +	 * permission check. The caller will do the truncation afterward.
> +	 */
> +	flags &= ~O_TRUNC;
>   
>   retry:
>   	if (flags & O_CREAT) {
> @@ -836,9 +841,7 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>   	set_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags);
>   	req->r_new_inode = new_inode;
>   	new_inode = NULL;
> -	err = ceph_mdsc_do_request(mdsc,
> -				   (flags & (O_CREAT|O_TRUNC)) ? dir : NULL,
> -				   req);
> +	err = ceph_mdsc_do_request(mdsc, (flags & O_CREAT) ? dir : NULL, req);
>   	if (err == -ENOENT) {
>   		dentry = ceph_handle_snapdir(req, dentry);
>   		if (IS_ERR(dentry)) {

