Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46CEF64397C
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 00:31:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiLEXbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 18:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLEXbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 18:31:08 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C8E13F3F
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 15:31:04 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id cm20so12754930pjb.1
        for <stable@vger.kernel.org>; Mon, 05 Dec 2022 15:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=B64nahlnQTvizzFWN/MKOqXMuPOFiJayfJ71EF7WbGA=;
        b=OdoCO3aIPMdfROqUjmXL7OEIA9CYBS2QJpBEQA/J/lXle82NRW52w+zlIhfg8ms1LH
         /TaN9ef8SYhihXbLecW289xcKfk+r8jWkj++QJwpEkQ1fXVsZ/FXGTthxTDx3eTv2LqU
         aF9+9jCAsL/TJziFYfMd+KTj2pD0QOxM5LCYt8tjyk5XsS1+uOrVx9Njw5OmkcBBVEYX
         KSGIvwzQcHLKi0zMkznu7zvWfx7VwIEZnBvI3Jh70JzLhhauK0TvqwYPjpm562G4twQ5
         bH2/dgjDSmgv5Ucv41xkKot6rQ9Ok5rWk8g0NNt3g0bAOZFq60lEilO/MyCxX0rMGr7l
         LCBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B64nahlnQTvizzFWN/MKOqXMuPOFiJayfJ71EF7WbGA=;
        b=fP+udX5sXr9z/X0Sm+Z6L0Rj3H6ylJeACQA+VqSmxessAhRQRVV0dP+Jhu8zK/Fp+v
         q2HQXC9B30l+ayVdYtqa+nPk8GF8eD/pD+B9uuIVItFUi3RyxNTbY7/fhmrR9h24zsdd
         WRYsMuS5xxHMWI2FEIJZ1RLUT6ecATdvnUnJzBawpCdZytCi8oAaIOHf7YnizBdQ6KoI
         xHXsZPwD+GzpyCXPeITa4zxd6EDAjPLaiJjwAO1ePjjE72gB5Y48L4YhHuOWtboQzbGo
         NXEKYBEgvtbVLluo4FCNg9xDrryOhnDF8lEiSBJxyNwtnGh/BYy4jkH/ZuU00M63bR/1
         I14g==
X-Gm-Message-State: ANoB5pm/8huvLzll7AVFuce3/HZowJeqfTbenqJ/Fr9YeVqasTjqo/Qe
        jX+/oskLbVAtdfhYfdIaK5Ktjlbqv8gz0GH4
X-Google-Smtp-Source: AA0mqf5QjTlWvI5ubzCjEUZ2XSBplUYzhwiX2VZlK2wbZvvlG5QcSd1Z2Q5+Y5Ulo+DwDdjITx4zAA==
X-Received: by 2002:a17:902:b685:b0:186:5e2f:44b4 with SMTP id c5-20020a170902b68500b001865e2f44b4mr59374pls.29.1670283064040;
        Mon, 05 Dec 2022 15:31:04 -0800 (PST)
Received: from localhost ([122.172.87.149])
        by smtp.gmail.com with ESMTPSA id e8-20020a17090301c800b00189b2b8dbedsm9188203plh.228.2022.12.05.15.31.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 15:31:03 -0800 (PST)
Date:   Tue, 6 Dec 2022 05:00:59 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     "Rafael J. Wysocki" <rafael@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        linux-pm@vger.kernel.org,
        Vincent Guittot <vincent.guittot@linaro.org>,
        regressions@leemhuis.info, daniel@makrotopia.org,
        thomas.huehn@hs-nordhausen.de, "v5 . 19+" <stable@vger.kernel.org>,
        Nick <vincent@systemli.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH] Revert "cpufreq: mediatek: Refine
 mtk_cpufreq_voltage_tracking()"
Message-ID: <20221205233059.izdqcilbhjmkh6ew@vireshk-i7>
References: <930778a1-5e8b-6df6-3276-42dcdadaf682@systemli.org>
 <18947e09733a17935af9a123ccf9b6e92faeaf9b.1669958641.git.viresh.kumar@linaro.org>
 <CAJZ5v0ixHocQbu6-zs3dMDsiw8vdPyv=8Re7N4kUckeGkLhUzg@mail.gmail.com>
 <CAJZ5v0hc8CsvqLKxi5iRq7iR0bkt25dRnLBd23mx-zdi2Sjgsw@mail.gmail.com>
 <20221205043044.bgecubnw7d3xlyi5@vireshk-i7>
 <CAJZ5v0gTV5LM_qRKncPq5Z2TRENMgVer6oZiGAKJn6ndrNSKxg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZ5v0gTV5LM_qRKncPq5Z2TRENMgVer6oZiGAKJn6ndrNSKxg@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 05-12-22, 13:08, Rafael J. Wysocki wrote:
> Well, this was a bit unclear.

Hmm, yeah. I assumed that the arm stuff will go via my tree and you
will be in sync with this. But yeah, a comment in the patch won't have
hurt.

> Alright then, I'll assume that the proper fix will come in through
> your pull request for 6.2 (but please send that one before the merge
> window opens), thanks!

I was ready with pull request since several days, was just waiting for
this to get sorted out. And I think this may get delayed a bit too, so
I better send the first pull request now and worry about this later.

-- 
viresh
