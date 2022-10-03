Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1982A5F27D9
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 05:31:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiJCDbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 Oct 2022 23:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJCDbY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 Oct 2022 23:31:24 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5BB2356D1
        for <stable@vger.kernel.org>; Sun,  2 Oct 2022 20:31:22 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qx23so1420738ejb.11
        for <stable@vger.kernel.org>; Sun, 02 Oct 2022 20:31:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=ABloi6KR4f1h19xF9pqW5xZu3d3NhgUwnMOhFcfII30=;
        b=fEjRjDGjZxv5gC5yefZ+Eag2SfZs5tUly7Vh0S5QgErK3uwVN/11JPn5n3nRv4PWG/
         zmBLuKh9dO3vMaSs5Vi+kwGSZ4j20uneWJEPPMGY82qy9NMKQ+tpcvaPp20furI4gWWW
         CR2u41aIzFjQNBSSot48ak3cWx8CFx4Owfvh68f++UNHh7fFZgMkyKBOEUUQm4i0UhKE
         kETluQu30Yi0OFuQuQSnV8U9H3yozIqMg5LjtWXAmBcCbDn2CAXDXw9fjuYrGnGa+hDN
         vayTIsiD8zrB97Sytf84Q2jc/sNMr63KmxbmmShh1i/HTfFxJnqsUmbEJC5Ckb8Y1PqK
         7zyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=ABloi6KR4f1h19xF9pqW5xZu3d3NhgUwnMOhFcfII30=;
        b=7qs39K+4JTJvWbUlpeT0HyJjIQWaLHxUeLhPVtlH2PTT7iop7QyuAPj5nubRTWcVDg
         bHI1Y/eog4aI5aq/aAYND7uX+ngyEI5P7fBIn7Ao9cHlW4+9qP9qeEfwlKDZ60F+BksA
         8Zcx4ymEseuu+67UN9cxLk16LT6T8NknZOQArK4/EHsy1VDwsXGeUhaPLVL7HCkyHODn
         /m5aOpEnreysEUcvwChloyx86GSyE/hVRRJ+4/CrsksbhuZ9mkHjVedxVMiJHrNluSMl
         UqdlGUIdzlvF2g9fKZCFXgKp7ijDOrzUlY/W/7x6Tf1GAc6o94Fwifo/jzxrra1yTN8S
         9aXA==
X-Gm-Message-State: ACrzQf00ywnLi3M9C9IXX/a0v9IpFxMN6O7sFUzb4FBUM8PRYYviOsgF
        l0fQD1gl5UuxwB5AiC7vdfP4kR6oUCe2MB7SOz0=
X-Google-Smtp-Source: AMsMyM6uQ+8lNWXoG6V15Vumk6nLQYRu6ivFm7aCY2AG5kqhzA4dFJ2bW8LRRvNeMhhEHVbh9GNVcEtkw45dy4XxOyI=
X-Received: by 2002:a17:906:5a5a:b0:78c:9b55:2693 with SMTP id
 my26-20020a1709065a5a00b0078c9b552693mr60884ejc.199.1664767881338; Sun, 02
 Oct 2022 20:31:21 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a50:794f:0:b0:1de:a0a9:6f60 with HTTP; Sun, 2 Oct 2022
 20:31:20 -0700 (PDT)
Reply-To: kaylajones612@consultant.com
From:   Kayla Jones <nayeadjayi@gmail.com>
Date:   Mon, 3 Oct 2022 03:31:20 +0000
Message-ID: <CAMicTEP6DeU7ZqSOufXjUaTDynTi_0YC6OT+yYiwuR1k7=jM+Q@mail.gmail.com>
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

Greetings, please check and reply the previous emails I sent to you.
