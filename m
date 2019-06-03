Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487EF336C4
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 19:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfFCRbU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 13:31:20 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:40475 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726808AbfFCRbU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jun 2019 13:31:20 -0400
Received: by mail-pg1-f176.google.com with SMTP id d30so8669034pgm.7
        for <stable@vger.kernel.org>; Mon, 03 Jun 2019 10:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=Zo4KbwYrGnCvltVt6+l8mD3pDLQr5ssDDaJK1FstCzM=;
        b=TAXNAkzZi+NX9mn0QyntssQSJP2qZUQb+XmEOm4vs9ZCSuzIK8cjovbWnPKJrZbK4e
         xtDzucO+xfDTOzphSFzbl+h5gRTbJ4LIs2qIrHmFoqoK0NtaVRyRF99wIdt2bhAftDyb
         xAc7lQc4LofpvTkkqM9S3X5albmV0m2I/biks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=Zo4KbwYrGnCvltVt6+l8mD3pDLQr5ssDDaJK1FstCzM=;
        b=i6nM2g8XDeGBGw3v7jvq0Ur8CT/4Ohpt2agtEwBeUCI8JtJ3xVifHeZ9D/UFjJwM/O
         LbKtHASmySW8m1fklZks25yg7ILP6WuxezBaw5jYZbjvX23N79wTklvfYZ0M/YTJVEfP
         egoWCmgajFw2aNwTU2u0/RMPwDYLHO9j+wQFPzqrmjbMJbpDunRluQfHyW81bX4e/cwp
         x9VnAlk787+Fa3UP7ta1hYF0TE+J2LbettRnxIXdVl3TFHrNnIckjDKZiK9KedVZ8O45
         VVBIDAF07QEKVhoC1QvqxV50q5qP7/xvDjZg9w7YEVChg/s1M9Ta2s0WibBx/U7tMQs/
         ZurQ==
X-Gm-Message-State: APjAAAVO6NWt58tCCZwxSoVwnsdWtPbqArvzmjSIX0EDXoLoNMmhlrCt
        XDcBfpmFOMEQMorGI2sgV+D90FZQxeM=
X-Google-Smtp-Source: APXvYqxsXxD3h+FAmBPQjOQ3QfpuA7DQyN/YJbyLsf0XrvCck62uXkLTgH/qgFEeWldZ8n4bHUUv/Q==
X-Received: by 2002:a63:5c1b:: with SMTP id q27mr5666517pgb.127.1559583079630;
        Mon, 03 Jun 2019 10:31:19 -0700 (PDT)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id e5sm16213358pgh.35.2019.06.03.10.31.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 10:31:18 -0700 (PDT)
Date:   Mon, 3 Jun 2019 10:31:15 -0700
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        blackgod016574@gmail.com, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in
 ip6_ra_control()")
Message-ID: <20190603173114.GA126543@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

CVE-2019-12378 was fixed in the upstream linux kernel with the following commit.
* 95baa60a0da8 ("ipv6_sockglue: Fix a missing-check bug in ip6_ra_control()")

Could the patch be applied to v4.19.y, v4.14.y, v4.9.y and v4.4.y?

Tests run:
* Chrome OS tryjobs


Thanks,
- Zubin
