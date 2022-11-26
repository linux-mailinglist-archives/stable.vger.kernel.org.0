Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D67D6394E9
	for <lists+stable@lfdr.de>; Sat, 26 Nov 2022 10:17:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiKZJRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Nov 2022 04:17:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKZJRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Nov 2022 04:17:10 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C375CE
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 01:17:08 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id h131-20020a1c2189000000b003d02dd48c45so1978825wmh.0
        for <stable@vger.kernel.org>; Sat, 26 Nov 2022 01:17:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnqBxln1m5jjnCc4bQGQXXiVBNS0bTJaIhMgoOQZMsQ=;
        b=NxNHgka/57OaQwGFA6PymTmC/26euQSiMQ8poClObGBD5mYmtg8Eok0ckxULMIIx6Y
         /7PJd72aBVLwlLq9dTRtT9i5217h0QcV5lIIiQkbCxd1fGoxY1U1J+l1XknHCMw+y0SW
         r1xLS3ntN/0FfnWU03FCx7pcpUFT35U/X+bIWver82YLwWG1JrFvCO0GSJixDJzZnyoj
         EjkplAUb/XSsCm5qn6bOfDh7ETsLrB0V3DSOpgDmy3UV4Uy80Z4NAdifxbrs7en+6N/U
         wfJItjxKdtb7TF0ljLRrKzgu/3Jv9W41M/CjDI7N5hwkQA5GTpPUB1Ovps2wV+YRaA5l
         N8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xnqBxln1m5jjnCc4bQGQXXiVBNS0bTJaIhMgoOQZMsQ=;
        b=M1yslHkie3WxYZR5n5EGqQAKWAmsU7674/x25gR0v/B1tyd/+97imtDy8hJq9jvYnt
         0mR+kDWUaSisMWbFFcQMfoYZnHI5CTo563ipHg+k8Ld3Ww+fMBVwrqRzY0qiMZRv00Ay
         EnhIX4y+xmaXW49xTdVtOq6zh2JQhQNvDqZwc2+EU0bFDqlBpXQI1XAoal0nHgr1Fhrn
         8FO7lANrGBIR/IjVnsYx/sn3JhcMeGA59NccPV5yo/tuIlDMy2agREOMW45ErjEA+wjz
         XuIF7psW4bjvu4rm/1tvm+ZKzmlcQasI3PmqTDlWqaU8zDTRYbbG8a26C3HPVKMkwWEY
         l8gQ==
X-Gm-Message-State: ANoB5plhgpMoxThEsNEdW/ws8rRwCFZPE6yowoegDkd9e0ROhFEL+uH2
        sSxbQYzfU2V+6IA2xvO2+d6Ohf11D4YLZ4yy0tM=
X-Google-Smtp-Source: AA0mqf6gjvUxCQ9iG5MarVrjWShkfUtbXnYQSiVWXurz0lHRoyb3T4J8Rl/govmb6hZ9VSQLP2flVZ8biJosS2MO650=
X-Received: by 2002:a05:600c:a382:b0:3c6:bece:49b5 with SMTP id
 hn2-20020a05600ca38200b003c6bece49b5mr25273820wmb.160.1669454226782; Sat, 26
 Nov 2022 01:17:06 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6000:1f05:0:0:0:0 with HTTP; Sat, 26 Nov 2022 01:17:06
 -0800 (PST)
Reply-To: te463602@gmail.com
From:   Michael Omar <pd858h74k8r@gmail.com>
Date:   Sat, 26 Nov 2022 01:17:06 -0800
Message-ID: <CAN4TRgcaKdBeVZCB3Qv1vKqXykjhFFfp5msLeQDegKwhQhPJmg@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Greetings,
We are privileged and delighted to reach you via email" And we are
urgently waiting to hear from you. and again your number is not
connecting.

Thanks,
Dr. Michael Omar
