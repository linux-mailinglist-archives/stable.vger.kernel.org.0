Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4293E6BFC78
	for <lists+stable@lfdr.de>; Sat, 18 Mar 2023 20:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbjCRTff (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Mar 2023 15:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCRTfe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 18 Mar 2023 15:35:34 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371821ABE5
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:35:33 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id v25so3631638wra.12
        for <stable@vger.kernel.org>; Sat, 18 Mar 2023 12:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=layalina-io.20210112.gappssmtp.com; s=20210112; t=1679168131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wra7/fAy4QvUsLcblmyUMY0619y8U0Wv2nTfMA9BmcY=;
        b=bpzd5gwnNTU+0ViRcZP8Tb0OQM0+pmzFLxfabD0BisWBx1H2y2tHWqez/rcLTGXilb
         b/x+7cIfhrWPx/xxyajtuZDre/XWXyijdpu9mrUPHUKYtlooFOFLLJA1v6EP0RDu5/6C
         JFz7wyrzE6INejrDdHnzmMsmDYokeKx+fggmdO04x4ang2T1G/SF2uUDO05rNkWNqmJq
         x6DnMDPVUwcVT8t4X0NyRtHqUuCYohbYVWNvC/dk2TQ5Hjh7TJ/9FiILnxVV0e+BuLZF
         1taQ8fmpXtvciRBdkn3IaQealEshFxs26OyebeOZiIln4uWps01fnKtTj+LF+XNVf9k+
         3SMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679168131;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wra7/fAy4QvUsLcblmyUMY0619y8U0Wv2nTfMA9BmcY=;
        b=pR2yhOgoTebT7i80LExdGfFZhltKnNNRcoNu38+1ieUq1VLFfgNbkYbQSE0GSZMwL4
         qCdRYm7YfMHjzysmZ0RJ7J1a6p8LxNzIzlJ3A13aIuWANonfyfgIIYpYXe0GH3x9t0mm
         aDjE5szlcnJvTzkIUFzyV87KcYEmJPT9ct1QR+cGctaIddwK6/wguMLfIduKiVpO9zWk
         BMGCZR5dgjL6pBn+rIQZuh0kJx3HRpjUxxzjEVbP6MbUfJ01+RpGZLC7/sSOmjW1dYsl
         CNUSJ/quYf63ka2yWKiVZ1nss5Te2ldUWlrPQqka5WYb36TbNC1MpWzUtBdKKJIQ6UCw
         W2ZQ==
X-Gm-Message-State: AO0yUKUcCTvOT8iUsG72VN7kxVG4pwxZCuuSbEr2t6k7TSy6PWsaNl1n
        FjgX72hU7+6ihGENyL7aGfTekw==
X-Google-Smtp-Source: AK7set+r1n82rrZ/4y4PgqZlgF8XkrldOafBtcXywda2LeCLlP2jGLJzfx3YQuEzPn4c99u9WBxlFg==
X-Received: by 2002:a5d:6589:0:b0:2ca:f680:cbf4 with SMTP id q9-20020a5d6589000000b002caf680cbf4mr11011216wru.39.1679168131719;
        Sat, 18 Mar 2023 12:35:31 -0700 (PDT)
Received: from airbuntu (host86-168-251-3.range86-168.btcentralplus.com. [86.168.251.3])
        by smtp.gmail.com with ESMTPSA id h4-20020a5d5044000000b002c70851fdd8sm5000400wrt.75.2023.03.18.12.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 12:35:31 -0700 (PDT)
Date:   Sat, 18 Mar 2023 19:35:30 +0000
From:   Qais Yousef <qyousef@layalina.io>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <20230318193530.bzb4b2g6wlukibr2@airbuntu>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
 <ZBGHpGccMmxHnUns@kroah.com>
 <20230315125304.g6yuhltvewnfneqs@airbuntu>
 <ZBLIvuqi0LYWIPBN@kroah.com>
 <20230318173359.agw5rq7gwwjdvnat@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230318173359.agw5rq7gwwjdvnat@airbuntu>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 03/18/23 17:33, Qais Yousef wrote:

> And they all compiled without an error. Happy to retake them or prefer a resend
> anyway though nothing has changed?

Actually I just did a resend. I guess you won't find them easily in your inbox
anymore.


Thanks!

--
Qais Yousef
