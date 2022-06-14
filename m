Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3C154B18D
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242909AbiFNMwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243635AbiFNMwb (ORCPT
        <rfc822;Stable@vger.kernel.org>); Tue, 14 Jun 2022 08:52:31 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32BC1D320
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:52:27 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id v143so11422437oie.13
        for <Stable@vger.kernel.org>; Tue, 14 Jun 2022 05:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=4mmDZ1uRPZfOmm/rnLqxwzYEdjUGRLpeFzpEL+z52QM=;
        b=SFueZ5ToabkczG7IfE0fgirvQIQBbRWianQGjk5fTWQnyGOs5BLoeWeQ3C4yxAUSPw
         0PNFoXwZKdWr+ASsdgp3Y8VytXtH49U2MOUm9GIdjpAmdHO19qcqYR7bcYVcj3dOBFMK
         fiORYuzAFvXy5OxmYkA6KjFormjjSZhd/R/Gw9Kp+QXNhwAKJbB/tGk9WPSawAL7LzM6
         jhXBRTDECjWwKz8M1IO2COnjZFHHF7iVUfxRwzb2EKcMIS2BUYe7KrJUxumLwlIoJ4WW
         OL+oZGtoeXLIcDD9dvARjViB6uQhfDUq2FfsxfAyXLrwkPpkpQpD4suyQjt2GFHzuPJ+
         FK/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=4mmDZ1uRPZfOmm/rnLqxwzYEdjUGRLpeFzpEL+z52QM=;
        b=xjZcUAImV4rI0IPBgHG24MF/W5xolaAkllZuh8fU5/NqSjPLgWQovA96Bl6GCWRnVV
         U+VzkyS7woeXSufSxxOt6JUUVPeQsK+RxrevIQCT0XnliLdBBQFRNLhjj9FxrX9bxJVl
         Sbwi6zKGjQJ9x0AqrpUZT5UpQraLI9ZvtJob6o9iaungtR4htZSfph+ySjMIsogPH5T2
         x5MSMdJ5mSdzjRWJ8XuMoOXpf3dkevU1U807XWiMo+al6qkOo5oaTtKknm1WhIFekjCk
         f/Nhy0ct6rzh+5sWfEZ99gsBpokYX/QzBxyBALN13le67VtYF/t4NYFkLkUPh0yIc2NO
         b69Q==
X-Gm-Message-State: AOAM532XxG2CdO4JxsO4JCSJSFhq9r5eFP+o4UdJ+1hI6XzD9DoGUt31
        82DbqEmR2+KiOl4TeUK6v3FaCefhqM67YQHSfp8=
X-Google-Smtp-Source: ABdhPJzc1iVvVZQw4eI19mMBTV1r18811AveL2g6YO5rQhJB1plrQ820wWw4t0QIAiDCQ6G+ot32ZCiDVHiDAAEiaZY=
X-Received: by 2002:aca:ac4c:0:b0:32f:1199:5963 with SMTP id
 v73-20020acaac4c000000b0032f11995963mr1974549oie.107.1655211146325; Tue, 14
 Jun 2022 05:52:26 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:6f95:b0:a5:7d3a:7129 with HTTP; Tue, 14 Jun 2022
 05:52:25 -0700 (PDT)
From:   Donald Douglas <ddouglasng@gmail.com>
Date:   Tue, 14 Jun 2022 15:52:25 +0300
Message-ID: <CALVR28GKMQr9RZqy5Oys2MW8S+cZfTCcpZB=orF3jd5tJ7QF7Q@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Donald Douglas,
For,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
