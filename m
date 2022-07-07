Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C1B56AEE0
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 01:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236446AbiGGXNX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jul 2022 19:13:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236216AbiGGXNW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jul 2022 19:13:22 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED63675AA;
        Thu,  7 Jul 2022 16:13:21 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e132so20911894pgc.5;
        Thu, 07 Jul 2022 16:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OIcLV8kY/4SFYYSts/C4rokiyhVrQ9h9RsVtESZwx4g=;
        b=kmnDhDib02O5Wv6KPqwoOtSr3sLKFrfLTPoSaZZWRZKDT72ZxKo6fuVpo7NMQREPQx
         1LGC8477toNm0a8IX5OV6mjwmGZOhg5nyaqo7k1E1eYLdPJ/BpBV9Ol607jo0VNSykt4
         bS9Aik0XkawYoIbuB4InT5euT8rD5spDUzLnsN3cpcaoKRrpKd2PWcKHG6h5CPPOnFGA
         na+SUnyyy10xMGBKpTCQmmvz507gE23oLpgs/galAjTVMaML/vd4GaSnlqH8uM8AEHIi
         VZHMRgCpYoFlO19YyGVicQt0ICBfftgZJUWTSzUBj8aHWkseHxHfuIhWq0eutkVyJIWu
         B5Fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OIcLV8kY/4SFYYSts/C4rokiyhVrQ9h9RsVtESZwx4g=;
        b=kAYR4EOkhNTBP4i1QegJ6x9l+FvcavgrD7XWz6zlaGGW9SZt4cXQn7AmCTYtei7VR6
         Mltm3U0HOCLH+BKqkxqC8S7Cj+X8l9dyYfDePeJ0aUfYTauB2THVrysGyIOYcRrUK80x
         8LnUlMsOuqSYLj5rx/sXpyAiv6jN6Mfk4iv5ctlqeuUooR2H373t0KgMJEbvw3ry7mip
         xTyPHUNogb/YfDKmOWI/AN5/FVu//9AGl0Jw69BpCWdGd/5HAHz6FwboCXZK+mKkPef/
         mYP3rnSKSKYozFd/rYV27F2JPCADCUn6UDoIgFK54J2rJVZ9wQqoYSccKy5F+b50Rin9
         kzKw==
X-Gm-Message-State: AJIora924QZrzuShzzHqWExophsnD9xwwzf5m4LExcG6QfJNVpbARLxL
        TCNibxwVmpPvWNmV+X/LZ4PgcoRUEfhJBCOyTr6HXXATys4=
X-Google-Smtp-Source: AGRyM1u3a+3w28svCbjLMJnd59/2pf1FgF142X/03RAI0L9Bo4RxtPDkMcvTkkHRheiHALGbmTwVOm/R2OeEjmPtvfQ=
X-Received: by 2002:a63:89c6:0:b0:415:b609:2458 with SMTP id
 v189-20020a6389c6000000b00415b6092458mr92317pgd.76.1657235601002; Thu, 07 Jul
 2022 16:13:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220513192342.7C8A0C34100@smtp.kernel.org>
In-Reply-To: <20220513192342.7C8A0C34100@smtp.kernel.org>
From:   Andrei Vagin <avagin@gmail.com>
Date:   Thu, 7 Jul 2022 16:13:09 -0700
Message-ID: <CANaxB-zXrkhzXzSUjon+4Y63GPJZNvhHyc+CmN6meUvCxh8BEw@mail.gmail.com>
Subject: Re: [merged mm-nonmm-stable] fs-sendfile-handles-o_nonblock-of-out_fd.patch
 removed from -mm tree
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 13, 2022 at 12:23 PM Andrew Morton
<akpm@linux-foundation.org> wrote:
>
>
> The quilt patch titled
>      Subject: fs: sendfile handles O_NONBLOCK of out_fd
> has been removed from the -mm tree.  Its filename was
>      fs-sendfile-handles-o_nonblock-of-out_fd.patch
>
> This patch was dropped because it was merged into the mm-nonmm-stable branch\nof git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

Andrew, sorry for bothering you. I can't find this patch in mm-nonmm-stable
and it has not been merged to the Linus' tree. Do I miss something?

>
> ------------------------------------------------------
> From: Andrei Vagin <avagin@gmail.com>
> Subject: fs: sendfile handles O_NONBLOCK of out_fd
>
> sendfile has to return EAGAIN if out_fd is nonblocking and the write into
> it would block.
>
> Here is a small reproducer for the problem:
>
> #define _GNU_SOURCE /* See feature_test_macros(7) */
> #include <fcntl.h>
> #include <stdio.h>
> #include <unistd.h>
> #include <errno.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <sys/sendfile.h>
>
>
> #define FILE_SIZE (1UL << 30)
> int main(int argc, char **argv) {
>         int p[2], fd;
>
>         if (pipe2(p, O_NONBLOCK))
>                 return 1;
>
>         fd = open(argv[1], O_RDWR | O_TMPFILE, 0666);
>         if (fd < 0)
>                 return 1;
>         ftruncate(fd, FILE_SIZE);
>
>         if (sendfile(p[1], fd, 0, FILE_SIZE) == -1) {
>                 fprintf(stderr, "FAIL\n");
>         }
>         if (sendfile(p[1], fd, 0, FILE_SIZE) != -1 || errno != EAGAIN) {
>                 fprintf(stderr, "FAIL\n");
>         }
>         return 0;
> }
>
> It worked before b964bf53e540, it is stuck after b964bf53e540, and it
> works again with this fix.
>
> This regression occurred because do_splice_direct() calls pipe_write
> that handles O_NONBLOCK.  Here is a trace log from the reproducer:
>
>  1)               |  __x64_sys_sendfile64() {
>  1)               |    do_sendfile() {
>  1)               |      __fdget()
>  1)               |      rw_verify_area()
>  1)               |      __fdget()
>  1)               |      rw_verify_area()
>  1)               |      do_splice_direct() {
>  1)               |        rw_verify_area()
>  1)               |        splice_direct_to_actor() {
>  1)               |          do_splice_to() {
>  1)               |            rw_verify_area()
>  1)               |            generic_file_splice_read()
>  1) + 74.153 us   |          }
>  1)               |          direct_splice_actor() {
>  1)               |            iter_file_splice_write() {
>  1)               |              __kmalloc()
>  1)   0.148 us    |              pipe_lock();
>  1)   0.153 us    |              splice_from_pipe_next.part.0();
>  1)   0.162 us    |              page_cache_pipe_buf_confirm();
> ... 16 times
>  1)   0.159 us    |              page_cache_pipe_buf_confirm();
>  1)               |              vfs_iter_write() {
>  1)               |                do_iter_write() {
>  1)               |                  rw_verify_area()
>  1)               |                  do_iter_readv_writev() {
>  1)               |                    pipe_write() {
>  1)               |                      mutex_lock()
>  1)   0.153 us    |                      mutex_unlock();
>  1)   1.368 us    |                    }
>  1)   1.686 us    |                  }
>  1)   5.798 us    |                }
>  1)   6.084 us    |              }
>  1)   0.174 us    |              kfree();
>  1)   0.152 us    |              pipe_unlock();
>  1) + 14.461 us   |            }
>  1) + 14.783 us   |          }
>  1)   0.164 us    |          page_cache_pipe_buf_release();
> ... 16 times
>  1)   0.161 us    |          page_cache_pipe_buf_release();
>  1)               |          touch_atime()
>  1) + 95.854 us   |        }
>  1) + 99.784 us   |      }
>  1) ! 107.393 us  |    }
>  1) ! 107.699 us  |  }
>
> Link: https://lkml.kernel.org/r/20220415005015.525191-1-avagin@gmail.com
> Fixes: b964bf53e540 ("teach sendfile(2) to handle send-to-pipe directly")
> Signed-off-by: Andrei Vagin <avagin@gmail.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>
>  fs/read_write.c |    3 +++
>  1 file changed, 3 insertions(+)
>
> --- a/fs/read_write.c~fs-sendfile-handles-o_nonblock-of-out_fd
> +++ a/fs/read_write.c
> @@ -1247,6 +1247,9 @@ static ssize_t do_sendfile(int out_fd, i
>                                           count, fl);
>                 file_end_write(out.file);
>         } else {
> +               if (out.file->f_flags & O_NONBLOCK)
> +                       fl |= SPLICE_F_NONBLOCK;
> +
>                 retval = splice_file_to_pipe(in.file, opipe, &pos, count, fl);
>         }
>
> _
>
> Patches currently in -mm which might be from avagin@gmail.com are
>
>
