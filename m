Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F24E167704D
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:43:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbjAVPnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:43:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjAVPnu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:43:50 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C407322791;
        Sun, 22 Jan 2023 07:43:38 -0800 (PST)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by gnuweeb.org (Postfix) with ESMTPSA id 65F8F82EDD;
        Sun, 22 Jan 2023 15:43:38 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1674402218;
        bh=EsafD2+Nb7Av1Ig8PMTqIWnwx9S3AVrtyIJCbVdcqOk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=GTE9zgc11SnUdycfeS+0exOc5JkRk++ike2BrjFhYGv9lTnOJpBvW7nc6nQxB8XQF
         w7skrPyNE6dndUyGlGidHnxuOck4iJvB1WEcoEOnmHqVrIuTXXza02fHyPqXPv5C28
         wdyHNGM8+bnzt30foupcSJqcjQY9nfuSlNfcfPHgtDoL4Qi5+osQvdCFfodP4PxQ6y
         J3Oot7Q3J7HN5FOJUslN3DAN6Ae8WIfn/b4pc1XB45bbLCDOK9rqyfWzQqCk8r0JeI
         HWt4VaVo9LIkfKm7t3rseK75+SuFkbTnl3IlnEBML8KYHhkjWcz6nwmITCTBct7X0m
         dU3NPp5ot3fjw==
Received: by mail-lf1-f50.google.com with SMTP id br9so14742812lfb.4;
        Sun, 22 Jan 2023 07:43:38 -0800 (PST)
X-Gm-Message-State: AFqh2kqKfSydg78eigJYxs7JmZ8FhAy5nApUeh5qQiUxGmEQbKp9tUOA
        +l8quAxUup/QuUErhtY4U0YfsSMLVLdw4wf0aEg=
X-Google-Smtp-Source: AMrXdXu2O/KN5fL5A2y5crPDdJ4eQ+YH7LO9T0ng+OcNe8VDgi9pNyiqo7RuIebB8W58wqOvs/J8xDJJv8Jdopy8uFg=
X-Received: by 2002:ac2:494f:0:b0:4cc:5a57:ba99 with SMTP id
 o15-20020ac2494f000000b004cc5a57ba99mr1383637lfi.678.1674402216107; Sun, 22
 Jan 2023 07:43:36 -0800 (PST)
MIME-Version: 1.0
References: <167439864617430@kroah.com>
In-Reply-To: <167439864617430@kroah.com>
From:   Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Date:   Sun, 22 Jan 2023 22:43:24 +0700
X-Gmail-Original-Message-ID: <CAOG64qO=iZZO-PJjmeYO5wKHAxn3ATDyj6g=FA_tx3WNAMBvug@mail.gmail.com>
Message-ID: <CAOG64qO=iZZO-PJjmeYO5wKHAxn3ATDyj6g=FA_tx3WNAMBvug@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] io_uring: Clean up a false-positive
 warning from GCC 9.3.0" failed to apply to 5.10-stable tree
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        kernel test robot <lkp@intel.com>,
        "Chen Rong A." <rong.a.chen@intel.com>, stable@vger.kernel.org,
        io-uring Mailing list <io-uring@vger.kernel.org>,
        "GNU/Weeb Mailing List" <gwml@vger.gnuweeb.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 22, 2023 at 9:44 PM <gregkh@linuxfoundation.org> wrote:
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

That uninitialized reading is living in 5.10.y branch now
https://github.com/gregkh/linux/blob/v5.10.162/io_uring/io_uring.c#L4989-L5017

If this:

   ret = import_single_range(RE AD, buf, sr->len, &iov, &msg.msg_iter);

fails, this one (flags & MSG_WAITALL) may read an uninitialized
variable because @flags is uninitialized.

Fortunately, if import_single_range() fails, (ret < min_ret) is always
true, so this:

    ret < min_ret || ((flags & MSG_WAITALL)

will always short circuit. But no one tells the compiler if @ret is
always less than @min_ret in that case. So it can't prove that @flags
is never actually read. That still falls to undefined behavior anyway,
the compiler may emit "ud2" or similar trap for that or behave
randomly. IDK...
