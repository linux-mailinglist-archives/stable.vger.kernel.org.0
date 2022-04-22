Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D43C50C4FB
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 01:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbiDVXnL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 19:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbiDVXmf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 19:42:35 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5155DA5E
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 16:39:14 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id d6so7076295ede.8
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 16:39:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=W3lk2/5S1li+q0loYlmeXcuz5hqhvffCdyGOR91sHdo=;
        b=C5BnZBTg1vmWVKuu67kkN0LZFJ94XhCGSnnePkaa+sK5V7gBxYbdWeLwpPRr5snwmw
         wfFNUZY4X7OrnnzK8g6xBT3Abo4o2LrOgz28coVHVKABz86d2kB2LRK7fD3SgKZgwSwf
         ntlDZNhtaIjBg8xyFaE/aufR3HbHcs1GiW4HB0JdiXA5oL7M1eGc8xSIXa9H1E1zl6NW
         tMxpGjRdfr/+Wh8gb2OiKTZug5d/RTFonKQtrWVOctEzToy+YtvvXfLuWK/yx5YIy9p5
         6Kt4c6kq4wUnbgrLqwOzrOwIQ9MWJ+UQ4jKtd/duuy81zVtri+HQ8Yxrzpuz7SyABY26
         nMHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=W3lk2/5S1li+q0loYlmeXcuz5hqhvffCdyGOR91sHdo=;
        b=uR+Qbms6N3of3SL33Jj7IBbxGEamllfvE4gdqvvQ7uM1MXQ2uRfZxtGyDkBSASLmy6
         EJBFrGA3V5lxbHBW/MW5lhQREOMO1c6Ihv5/QI+m6qz/AdGfy9zYlDluSHDKKhsMu4CR
         2ucfcRty0wYQzufxViPzXLR1C9XSGrJOA+/SYKk59WCTyxFm940X0HKhFYnlQbJ7UPya
         H+K2LX9i9l+bMyqR0Q1KP+VPiG3cIHKD4M9cWXmKv/MwwR5RyhDqsw5rwYHTMQRQBuUa
         RWGlsZpmKKx0h9gymGsMiKuBjgPhmmvGJGZHu5SDF3SExePfLrko0AtXTkH1N5WeNSmK
         aeoQ==
X-Gm-Message-State: AOAM531PsVzEH+vZ3BhEUMkWP4MS2rBhenzlTSDpLcWTrdxCMYp+LOmd
        U5DciukRI5csFeg4X/kM+UYPKB1G5j3Vv7TinXTaeiZnBysa
X-Google-Smtp-Source: ABdhPJxddzkeIEFi8924VdkEaTiydG8g24E/kibGjo7Phz3IC3vltmeBVZNn9UpnXmAFlW6vQvOuFEUmNaIenwmDRI0=
X-Received: by 2002:aa7:d397:0:b0:425:c0e2:b92e with SMTP id
 x23-20020aa7d397000000b00425c0e2b92emr5088322edq.4.1650670753026; Fri, 22 Apr
 2022 16:39:13 -0700 (PDT)
MIME-Version: 1.0
From:   Robert Kolchmeyer <rkolchmeyer@google.com>
Date:   Fri, 22 Apr 2022 16:39:01 -0700
Message-ID: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
Subject: Request to cherry-pick 3db09e762dc7 to 4.14+
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

Commit 3db09e762dc79584a69c10d74a6b98f89a9979f8 upstream ("net/sched:
cls_u32: fix netns refcount changes in u32_change()") fixes a crash
and seems like a good candidate for stable trees.

The change fixes 35c55fc156d8 ("cls_u32: use tcf_exts_get_net() before
call_rcu()"), which was added in 4.14, so I think it might make sense
to cherry-pick the fix to 4.14+.

Let me know what you think.

Thanks,
-Robert
