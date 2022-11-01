Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCB4F6152B3
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 21:05:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiKAUFd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 16:05:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiKAUFb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 16:05:31 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D89551C437
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 13:05:28 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id s15-20020a170902ea0f00b00187050232fcso7024968plg.3
        for <stable@vger.kernel.org>; Tue, 01 Nov 2022 13:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hRvAxWCh4EAtAm95k1ngY/EtNuIZmlukHpnGQzAr4KQ=;
        b=Ubs95tAVNsT2UoIpM9eGfl1NEnMB19cbNwzz4CxgtyGzKlPMA0DpEak/xGt5rHJwJp
         EyvK3aBJ975Jp0OYyiyH8bQSD4pguy74NN+IRlpKeMc7UXQj30ojnDJ98UbVqSXCXzlp
         w3q6gRniptQC8ycBLnHYEgELqNcCLuWbTpdKc1sFNHC9zK1BT+27NE9SfOSDw4cTJpuE
         nIwIjhhIIzfEFcUUSk8qwCIJrPLbVw6LVUY/SHkO81XfPF83+5/HXz+F6UPUY5uU24Bi
         Tn77cxgEsWMNCVj6p8MY3Q+LnpEiZwdijwpnc4UaoG6cSy49nipSkwdkKp5fPteSw8Wy
         VcPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hRvAxWCh4EAtAm95k1ngY/EtNuIZmlukHpnGQzAr4KQ=;
        b=Avf3Ee4cs+ntJT5Dl8THzaSb194ScboLEeY3gMKScfFaWFWpIc1NfYh3GrxYYG5S8A
         lWGTPJG8GXKZ8OCahZC1nlAHMymmko3RbxYOTIlXmDz6a4TPUh9F6KWJhHkrxeV5bX0J
         q8KZbYMugsJYKmgcSEe+7c4vqdn1UcAdxFY662r1Icr3jFXebG8ocAfrpA77KhRVUBGX
         m0ocLWuB571V4fqq1FQcjWyApi5m7hAOqzT0ahsY4HKIDo8C5FbEYZTwDQKFF5iFFJdc
         kFabjNlTrY1Kbiig3jk7BlP6Z5BM2AqEyHV9KVKqSexnQcmPs4+jDr3S68M0vRUd5QC7
         HuzA==
X-Gm-Message-State: ACrzQf1+PqbfqPdkhh4KC6HU/0YtZNcYNymMnL9wIysgmZaELaM9LaMH
        tPCcC0JBM/Bla/XX2coKN2DuJO5hsaO+ELI93eNWBIPnSXWQzSRt3R3TVo15ztQrYwTo1zLrlvb
        t5ndUfGIly0KqvUv+zt8uH10lmMfuNOSq8ixhH0SEySrUSkBHd47Bg2xlan7VGLVWcaHoMmBum9
        YVYTPoKXw=
X-Google-Smtp-Source: AMsMyM6rQIIqXgBgNAUPETvWn0IOsCO0hGucaO93DiOpRs+5zR6ZZHqi0rbkyWEJO/Am6EyZUWXJt2lCFwEg9rNfVVcXdA==
X-Received: from meenashanmugamspl.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:2707])
 (user=meenashanmugam job=sendgmr) by 2002:a05:6a00:3497:b0:538:17f5:64e8 with
 SMTP id cp23-20020a056a00349700b0053817f564e8mr185305pfb.11.1667333127896;
 Tue, 01 Nov 2022 13:05:27 -0700 (PDT)
Date:   Tue,  1 Nov 2022 20:05:04 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.1.273.g43a17bfeac-goog
Message-ID: <20221101200505.291406-1-meenashanmugam@google.com>
Subject: [PATCH 6.0 0/1] Request to cherry-pick 3c52c6bb831f to 6.0.y
From:   Meena Shanmugam <meenashanmugam@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, kuniyu@amazon.com,
        Meena Shanmugam <meenashanmugam@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The commit 3c52c6bb831f (tcp/udp: Fix memory leak in
ipv6_renew_options()) fixes a memory leak reported by syzbot. This seems
to be a good candidate for the stable trees. This patch didn't apply cleanly
in 6.0 kernel, since release_sock() calls are changed to
sockopt_release_sock() in the latest kernel versions.

Kuniyuki Iwashima (1):
  tcp/udp: Fix memory leak in ipv6_renew_options().

 net/ipv6/ipv6_sockglue.c | 7 +++++++
 1 file changed, 7 insertions(+)

-- 
2.38.1.273.g43a17bfeac-goog

