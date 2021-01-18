Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94CC02FACF3
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 22:47:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389250AbhARVpU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 16:45:20 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:41623 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388860AbhARVpN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Jan 2021 16:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1611006227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=33E7CE1iD039M2CodYIh0In3kgh4QjNGQGlN7uqYF/E=;
        b=PEM7EI401Ub0YMYjlxGeIGoUMH9j02K2xXk/n53cxFperYvL4sGJhie6YTwuXVHKjSZ0bm
        6yLM3AGcKbWS67WKebggjJFSjHADLSCR+IVHGZTd8VOZ9GWFuAnlgj8mdDplC1+HKoBdDs
        rfVGjNe441U/xycm2iUicgO0rOzQR5I=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-241-SCXxDC4vMZe1qi4AhhBMcA-1; Mon, 18 Jan 2021 16:43:45 -0500
X-MC-Unique: SCXxDC4vMZe1qi4AhhBMcA-1
Received: by mail-qt1-f197.google.com with SMTP id d26so4679540qtr.0
        for <stable@vger.kernel.org>; Mon, 18 Jan 2021 13:43:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=33E7CE1iD039M2CodYIh0In3kgh4QjNGQGlN7uqYF/E=;
        b=fP9TnB7TBgQYeKVoXbAtWhYRewOHULYwqRhM9brB3V3IY8K/VgxOQgQjPFUl3xPOvR
         1hij2DYIfX6hHG347pJ7UcOv+imsq6zZMynt2b80087RRF6EMmwwXkt4ghz/RA0wtQFt
         Ss9rHN/NpLKTZj7yMU8r1omMnZsuiJMsOWY7/FXMOi485LuLINUsssfpFKsQTyW/1kK0
         zMepxwYn/HKYTi4NNV+EzFYVcMClgKarGlu26WsdIirhDzm4eEN6vnLYsQ0vV+sgy81e
         K2Q3eQME1+fD7UCUuyVNFB+TPT1JMKSKW/cQusbQGd27HQUMLJHzrFkQM7pvL39v/574
         RIXg==
X-Gm-Message-State: AOAM533EJPCTZaMCuu9AoHyv6NgsWuavAuyUL63AoVwQU9tnLxU/AZs5
        oVqYiyk2+ysqhiyK1bAUQcADUXmgx6Zs8eSgzfOtF5BuRYCFufrYRLIbA+zFPvNx8Jwm606KCBs
        lnKiyM+65FBwUFy7h
X-Received: by 2002:a0c:fc4e:: with SMTP id w14mr1387192qvp.23.1611006224819;
        Mon, 18 Jan 2021 13:43:44 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxNKx7hUCVfvYbYgNL5JeFkWD4w40skB8lKucGVY2KkjhFTkcLfeY/Hrpx4ADSoht+Limc0hw==
X-Received: by 2002:a0c:fc4e:: with SMTP id w14mr1387182qvp.23.1611006224662;
        Mon, 18 Jan 2021 13:43:44 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id g28sm10944565qtm.91.2021.01.18.13.43.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jan 2021 13:43:44 -0800 (PST)
Subject: Re: FAILED: patch "[PATCH] cifs: check pointer before freeing" failed
 to apply to 5.4-stable tree
To:     gregkh@linuxfoundation.org, natechancellor@gmail.com,
        stable@vger.kernel.org, stfrench@microsoft.com
References: <161089298836182@kroah.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <fb17d5b5-94fc-2d11-7c14-83eb71219211@redhat.com>
Date:   Mon, 18 Jan 2021 13:43:42 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <161089298836182@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I made a mistake on the fixes line, it should have been

Fixes: 06d57378bcc9 ("cifs: Fix potential deadlock when updating vol in cifs_reconnect()")

-       if (!IS_ERR(vi))
-               free_vol(vi);
-       mutex_unlock(&vol_lock);
+       spin_unlock(&vol_list_lock);
+
+       kref_put(&vi->refcnt, vol_release);

This change is not needed for 5.4 unless the deadlock change is also needed.

Tom


On 1/17/21 6:16 AM, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 5.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From 77b6ec01c29aade01701aa30bf1469acc7f2be76 Mon Sep 17 00:00:00 2001
> From: Tom Rix <trix@redhat.com>
> Date: Tue, 5 Jan 2021 12:21:26 -0800
> Subject: [PATCH] cifs: check pointer before freeing
>
> clang static analysis reports this problem
>
> dfs_cache.c:591:2: warning: Argument to kfree() is a constant address
>   (18446744073709551614), which is not memory allocated by malloc()
>         kfree(vi);
>         ^~~~~~~~~
>
> In dfs_cache_del_vol() the volume info pointer 'vi' being freed
> is the return of a call to find_vol().  The large constant address
> is find_vol() returning an error.
>
> Add an error check to dfs_cache_del_vol() similar to the one done
> in dfs_cache_update_vol().
>
> Fixes: 54be1f6c1c37 ("cifs: Add DFS cache routines")
> Signed-off-by: Tom Rix <trix@redhat.com>
> Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
> CC: <stable@vger.kernel.org> # v5.0+
> Signed-off-by: Steve French <stfrench@microsoft.com>
>
> diff --git a/fs/cifs/dfs_cache.c b/fs/cifs/dfs_cache.c
> index 6ad6ba5f6ebe..0fdb0de7ff86 100644
> --- a/fs/cifs/dfs_cache.c
> +++ b/fs/cifs/dfs_cache.c
> @@ -1260,7 +1260,8 @@ void dfs_cache_del_vol(const char *fullpath)
>  	vi = find_vol(fullpath);
>  	spin_unlock(&vol_list_lock);
>  
> -	kref_put(&vi->refcnt, vol_release);
> +	if (!IS_ERR(vi))
> +		kref_put(&vi->refcnt, vol_release);
>  }
>  
>  /**
>

