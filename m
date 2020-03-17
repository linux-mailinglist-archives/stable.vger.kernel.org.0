Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD7521877A4
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 03:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbgCQCDa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 22:03:30 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45390 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgCQCDa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 22:03:30 -0400
Received: by mail-pl1-f193.google.com with SMTP id b22so8875004pls.12;
        Mon, 16 Mar 2020 19:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=TLPZH8MSQUe0XEeOtXK0u5bxsOUqet47Nx1B3C0W6qY=;
        b=BpeRPbZYeNLe7kYaSNNe54at4OHeQCTJ44acqyG9l3H9tIuuOLgu8uv6DXh7o+0bja
         GTvyRS9si0B9cNEonRQFccuj7DA1trwZOzBcKzQ0v8OvbkFBGGIRW0laWyd07eLb+/I7
         IH5OsJtCcnAm+9PrGlbu6rqwXtQCMM+pXk5MgQUTvDjUtibz/aFeGqBoIKhwwmF8vhqy
         om4XR1fhsi85DeUw1BLESWIEzUjEQEeUvR+GgJhcNOsKq6GrJj/9rIR1WY6aKXBlcWuT
         mUSx3vy4RFBOdWUJ6lnKVxhzRh44kf9AQ8KyFcWBbGjH23rI6H0ZigOfWCGH15jAIxCp
         tZ3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=TLPZH8MSQUe0XEeOtXK0u5bxsOUqet47Nx1B3C0W6qY=;
        b=bu9cSy1p+MeJ3BZ5Q6/8vet4PYtaaRcavqGqkfSDVch5ZHPNyk4EeRbpOQfmXV4e30
         woiO4QqiZQIRSdF4XXGOIxbY6BDVa66D1a48/EMCk2FWvdZOIViep7xwXsz5znVt+gji
         Lur5LHTycIfcBmDdNK9w1/YYDm/NFqRq503sguLuqx62C9k6dX31H8UOWl8mOunSRpu+
         yx9l1IiD74yH414o+ybj7oKn0r0cPldLH7dUxaVuDcAY83zDaLBaySDRsCNVehqI0b1p
         yeRH8cLlx5qd7Sosay10fm+7K/Rn1+7dZWp00RT8Rw4DYlDkq0n5RHFJx4sRJE9deAyF
         DAkA==
X-Gm-Message-State: ANhLgQ1Uwv2Ijk/kruKC9LNWaYPDAyYDTd/ld9KM51xBjb9oCjFNki4T
        +Jn8RZm3bEYupfqx+LID/uY=
X-Google-Smtp-Source: ADFU+vvwzo/8YvgEgtuE9/4viAFrN4X+4tnzlYKbLJ1+Aazp6UPQLHcMBpvHiumskpE8ueCc/sYYDw==
X-Received: by 2002:a17:902:d691:: with SMTP id v17mr63145ply.199.1584410608881;
        Mon, 16 Mar 2020 19:03:28 -0700 (PDT)
Received: from localhost ([2401:fa00:8f:203:5bbb:c872:f2b1:f53b])
        by smtp.gmail.com with ESMTPSA id s125sm670210pgc.53.2020.03.16.19.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 19:03:28 -0700 (PDT)
Date:   Tue, 17 Mar 2020 11:03:26 +0900
From:   Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To:     Bruno Meneguele <bmeneg@redhat.com>
Cc:     Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        pmladek@suse.com, sergey.senozhatsky@gmail.com, rostedt@goodmis.org
Subject: Re: [PATCH] kernel/printk: add kmsg SEEK_CUR handling
Message-ID: <20200317020326.GC219881@google.com>
References: <20200313003533.2203429-1-bmeneg@redhat.com>
 <20200313073425.GA219881@google.com>
 <20200313110229.GI13406@glitch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313110229.GI13406@glitch>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (20/03/13 08:02), Bruno Meneguele wrote:
> Ok, I poorly expressed the notion of "documentantion". The userspace
> doesn't tell about returning -ESPIPE, but to the functions work properly
> they watch for -ESPIPE returning from the syscall. For instance, gblic
> dprintf() implementation:
> 
> dprintf:
>   __vdprintf_internal:
>     _IO_new_file_attach:
> 
>   if (_IO_SEEKOFF (fp, (off64_t)0, _IO_seek_cur, _IOS_INPUT|_IOS_OUTPUT)
>       == _IO_pos_BAD && errno != ESPIPE)
>     return NULL;
> 
> With that, if the seek fails, but return anything other than ESPIPE the
> dprintf() will also fail returning -EINVAL to dprintf() caller. While if
> ESPIPE is returned, it's "ignored" and the call still works. The way we
> have today make kmsg an exception case among the rest of the system
> files where you can open with dprintf.
> 
> One of the things I could agree with is removing the SEEK call from
> dprintf, since fprintf basically follows the same steps, but doesn't
> seek anything.  But at the same time, IMO it makes sense to make kmsg
> interface complaint with the errno return values.

The code in questions is very old. So let's add the missing bit to the
kernel. At the same time, we probably can have a slightly more detailed
documentation / code comment.

	-ss
