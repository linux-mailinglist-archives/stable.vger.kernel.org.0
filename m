Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E72CF5FDABC
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 15:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiJMNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 09:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiJMNWv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 09:22:51 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98FA12FF80
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:22:48 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id o17-20020a17090aac1100b0020d98b0c0f4so3522643pjq.4
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 06:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Osa2MW4E6zKZGtpfwxTQaRbuOpSnAP2lq86wQZo9M08=;
        b=aT5pNl4CdAMczqIL9DHV2rrWO6ztXtUbsOqtk6JUrqCcmjA6w1T/BqGQye/JNnPq+H
         gku+HxGIlmX3GhJpkD/da2d5Wcd9OJCYZWC1Hq87s83xLLAg0egDfy7Nr4ZDtxbix3Uh
         nEizr8mtSwvuOeNeedJl5I6xS8r2LwnwkufKI5P6UtLpOSYUfMoEu0I1IuaZ8jg3aYeU
         m/oSb4ZGbhWSGVBCUQsrvb3ExMhgFl2QDEuw+Rel9w7VT9+DZ0YScmEU5sLKRzmWmPay
         2tGeHUG84LDh9MhDAcQdTN+jwg2JMwihIew2Jdj1oaCCoUqWwbVhAPatAO8g7litObbC
         hMDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Osa2MW4E6zKZGtpfwxTQaRbuOpSnAP2lq86wQZo9M08=;
        b=BJgdSRcDddBhYz8DBQKXaoVP5mG4pWokhM2WKdWZhmeZSno540veyS1kA6TWZ7qv4p
         0naH6I/wSYGzkOlxCP/u9de6743oQ4jjSbJSmJVOexi4lzxb9asfU+lLBQZL37JY+d13
         0L48RlE3VJOUBqXigNtuIYkkUDXye1FyGKbMbeMw/xuiZWBJ4m2kq0bBR8pf75YYtucT
         lock5myN7IJXYThQpoge2kHyzvKvyOb1Kdrk695mVV9ey2l80YEO5nFAGJRTVf0uHp5b
         IdJJ6ibzMLlKffm1oETKttreisLjPQJga6oyPVSQfBOxaqtUa9oWUfbuXvrtLaWxwcZt
         9eZw==
X-Gm-Message-State: ACrzQf1T/FbLemmgaSFfiT1GsNizxGPmoBr+UgTAgFxoF1uY3hirsgBX
        6kpDOb9FzXlpQz++GKkn2Wvor+ltwcV0B/TjWkE=
X-Google-Smtp-Source: AMsMyM5RyvctOudSYJkze/DDLL3uaTejpa48Zm/RhOdYeFZCcHlZb8z3YLOo1dhIF1N3tqmyb70KnLkcrRctyiiLWbg=
X-Received: by 2002:a17:90a:1a46:b0:20a:fef9:70f0 with SMTP id
 6-20020a17090a1a4600b0020afef970f0mr11315552pjl.190.1665667367348; Thu, 13
 Oct 2022 06:22:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7300:7691:b0:7c:a6ca:7fdb with HTTP; Thu, 13 Oct 2022
 06:22:43 -0700 (PDT)
Reply-To: dr.salisumummadou1@aol.com
From:   "Dr.Salisu Mummadou." <jeniferalbrnurse@gmail.com>
Date:   Thu, 13 Oct 2022 14:22:43 +0100
Message-ID: <CAOL5qkOCnAuCa2W4N5HEqgsLm8NYY_v4iPa8Nsvh8S3i8zUiww@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greetings from Dr.Salisu Mummadou, can i talk to you, very important
please?(dr.salisumummadou1@aol.com)
