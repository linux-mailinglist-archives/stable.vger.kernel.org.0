Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279A467C5FB
	for <lists+stable@lfdr.de>; Thu, 26 Jan 2023 09:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235981AbjAZIhT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Jan 2023 03:37:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbjAZIhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Jan 2023 03:37:18 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6C82680
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 00:36:46 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id z11so1216413ede.1
        for <stable@vger.kernel.org>; Thu, 26 Jan 2023 00:36:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unima-ac-id.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vBBydtjTCNoLHoaikk4MVmH3r+okeVfzKA/E+1BXIiM=;
        b=1jQy5ayWMQkBokEXcQkvGyL3FYRWUIOd5uG71A0WxcqRf6EIOxaZp6UrglX82ww2JQ
         CUJ7Zbe8CvuKk/j+p2SdaU8eW9VV+UetGpIIzwivXwQp1jbKqnSko+jDw0nzmD0X0j+f
         t8OeqAuPycUzpHuuenBgZ1uyf9sV3zdn/0FSYGY7dG1IShKrDj0ZNQttz4A9uWd7QOf9
         OJDtBiqNH8SzcAVrM53LWgpUwkM9JD8ZB5yicIgnz3tcZPI0xzQfo8EFcv/5KScG0/Ik
         YGexnu1g526n5Tuv80BjwPJhipylbc+c9EyFj+9eQUGRXVKelO272w8Ww8eJJiPc/pul
         QykA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vBBydtjTCNoLHoaikk4MVmH3r+okeVfzKA/E+1BXIiM=;
        b=X7cOPlKJ2eHTYWcFAevpp9EQxsB7gaPX+GKmflXqJhu6m94SoNmokkxpjNoDHv0qsb
         g0VYmTwT1DJKOrfj2OnfHkE8ms1e7ktNzU8qFWLwGMEuJhBZWJmDBEqnLX1wHkcz1lo/
         GyxKLCpkDLZY6qeX4IIrUm0Q4LAueojkXVrfKkuNa5qtZmodceHzPKJqgGrv9Rzz4zwl
         PwaH45DvXk46Nz/6Fsuh0sUVgUS/AD6nMlzn5vAxZfnfiOZpO83D8MQ+xNBPOshHCGee
         NcYD/pvpKfM3M2R9EeJJZPOKfIj7qO8TxPrrDa0fGAu9B471HHJcchxU/1pA30b69ZHa
         0F7A==
X-Gm-Message-State: AO0yUKVULJyiJv3bm7Pu8ibWOnq3fWlk0/cPH9O5DTVbrjD97+3K3/az
        1x+8InVxbwb22aQUxkROtqkkwwZcC83rcBnW7LzboQ==
X-Google-Smtp-Source: AK7set8wXhG2vA+5IWDYxyKsS+iiqqYky0jrMUS29ha+Q3NksuyiTc4Yq4cmiY2JgSSyBhDxHTJb5hvaM75KHY/TLF4=
X-Received: by 2002:a05:6402:175c:b0:4a0:8f64:cddc with SMTP id
 v28-20020a056402175c00b004a08f64cddcmr1562526edx.58.1674722151059; Thu, 26
 Jan 2023 00:35:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:82c5:0:0:0:0 with HTTP; Thu, 26 Jan 2023 00:35:50
 -0800 (PST)
Reply-To: lisaarobet@gmail.com
From:   Lisa <herdylio@unima.ac.id>
Date:   Thu, 26 Jan 2023 08:35:50 +0000
Message-ID: <CAJZsAoo_7-1_bEa1J=o_g2y7M9dxcEUA1OrKfmMTSP-pD51XDw@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FORGED_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear

How are you doing today?
Please tell me do you receive my Request?
