Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D31A6614DA
	for <lists+stable@lfdr.de>; Sun,  8 Jan 2023 12:54:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbjAHLy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Jan 2023 06:54:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjAHLy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Jan 2023 06:54:27 -0500
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3123E023
        for <stable@vger.kernel.org>; Sun,  8 Jan 2023 03:54:26 -0800 (PST)
Received: by mail-yb1-xb29.google.com with SMTP id t15so6206733ybq.4
        for <stable@vger.kernel.org>; Sun, 08 Jan 2023 03:54:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ym8iqDLCBJ1MXz75ii4GKKDw1zww9xi5CuvtZ9/NdlU=;
        b=WodN2t8yK/ts6g1Jfvu4BnYQk5coy5atzbAZHH/7miOSB/mNcwUKFY1wUykk8QSmg/
         dhBEs1v3t4xy0+YA0joC9K9VrWG2ohAm0YiiQZbd/83F7SSLysyJTgRCTu2DqTndQqjn
         0Ly6VaUp8umOogWEaYutkbD77xzZH/xw/7rkvw3pEOssUCdYGthPkH2PTB5zAziwtnVs
         j6vWF76kaWdOyNUoAskA/eierzj68OZAekLl4PhGKisBLZ9mIO1FLejoaAPnju7RcMeG
         uS0qNh4cG7k4592vdyzBxG3uz8yMGooMB/6jcAXfjYYXHOtfscM0tryMJ+1AcRFrw5uB
         LiJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ym8iqDLCBJ1MXz75ii4GKKDw1zww9xi5CuvtZ9/NdlU=;
        b=1/kzqSY6H52Vm+WzTdS+jqGzU1TspAm3UMN3mgqOjqk9IBPCVSbGLHRdVFBVJ6udjm
         kSq18lSUNE1R9SxNoDc3hM0OuNOta8CwDwe6ZJXX6EJ/rSkgnkFVlzp6dU0g7sWf3X47
         zinXtswSqi8yJJPBa40uf0Nm31qaaM2ZO8fiFiN+d+kAqTEzJV7054ECbHhUvw70kWPR
         aQEA2WSMG6hg5dj0qQOuuTBgy6Smt4kFszqrBdLSQkhNR4fDAk4SdCfU/EgyvMuBFth1
         sFoEqyUgMSGZo5z6hxa/wpwOAPZfPcnQd9UDx1C9fIUCW/N5OQGe45pcLNEOqHjx460V
         0LUA==
X-Gm-Message-State: AFqh2krWc2qC/PYowwYxXc2YqzJs4UGdcNN8TwVfdP6Z3+Acqx7zQ79P
        Um2ou10400lPz8n+4snYqfzQOuTqrTRXwn0m/T0=
X-Google-Smtp-Source: AMrXdXsCXjWnxwgZ812bb906aaTXPsVimvDqtIDdGCffxiG4g+XgrytLbDPdKx9ybz937/YvOEsvSNCu3S+QgvvXhc4=
X-Received: by 2002:a5b:305:0:b0:707:473f:b763 with SMTP id
 j5-20020a5b0305000000b00707473fb763mr6601036ybp.158.1673178865953; Sun, 08
 Jan 2023 03:54:25 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:634b:b0:320:3946:ae33 with HTTP; Sun, 8 Jan 2023
 03:54:25 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   Latifah Adamaou <adamaou882@gmail.com>
Date:   Sun, 8 Jan 2023 03:54:25 -0800
Message-ID: <CAFDHBsvOMzpM6+Yf+tqgddP722DQzqVbV8ntmtU3o14ePtawaw@mail.gmail.com>
Subject: Very Urgent,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
I tried e-mailing you more than twice but my email bounced back
failure, Note this, soonest you receive this email revert to me before
I deliver the message it's importunate, pressing, crucial. Await your
response.

Best regards
Mrs. Latifah Adamaou,
