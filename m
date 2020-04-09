Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6996D1A32AB
	for <lists+stable@lfdr.de>; Thu,  9 Apr 2020 12:42:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDIKmV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Apr 2020 06:42:21 -0400
Received: from mail-vs1-f52.google.com ([209.85.217.52]:41915 "EHLO
        mail-vs1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgDIKmV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Apr 2020 06:42:21 -0400
Received: by mail-vs1-f52.google.com with SMTP id a63so6592060vsa.8
        for <stable@vger.kernel.org>; Thu, 09 Apr 2020 03:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nZ0QmwMrKdYR47UUIs9Db5SI6uBXbCdulYeaCwUvGPM=;
        b=IEilPQejN7cBxNxTdlOfuXlaLboGoHtvhtygwF7gkXdDQZ+8mzeJDHGUVNHm67i1qD
         WiauG7rMjQg0CYBpReDWw8GqdetjAIFWPQJyAXdXbN8XqrL80CvBM1lVwLiwgPyyB3ZO
         mE8CmWK3N8Z57wbFcWh101ZGT7J0ZkH2fT3ggahLpbSBQNX+m+Hnxl2h8nnv3KF0CyG6
         x72luWapE7zGTCEOxcZnUx3cmWGhrNVvLQjXcqu732FwQ8LQp4NRRIm4ZmD0WEGtw04V
         Qfcn56bpoDa4YClZ9xGdXPdysW9kSTPsPwMZ1kGjPA1bGbYCsS0pDM9utlIcP7rBREsu
         nTIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nZ0QmwMrKdYR47UUIs9Db5SI6uBXbCdulYeaCwUvGPM=;
        b=Bh9gCQsdj+7wW4uW6WM/oc75uFoURducaISLx5NbTlxF/iXQZW1rrClIINMwt5VpHj
         V/mswssbl04r5Yqi/JeFLbMvQV1zEL20hr7nAxDXe6spXuBtH/Y72+9i7ZQWhqqNJR1+
         2qEpA4JgMBa/U4ICSHkmZHCzCKA9VAE0yvXcy0EO7zhOMiMU/XgVQ/RH9ynuFi7yJUZU
         d/OhFP/3TFfbH1Zxutb4oWw5zGTBFHvJ5hMYQtUy0gt9VjTGPufDqk+qefbhJIqHcjOg
         zvcYbcFmUJ5e4gteYnrBkj3UnzBc9bXnW+8rOVd4eEu00VJtlSztH0MkWErryOOTi02U
         xSxw==
X-Gm-Message-State: AGi0PuZ7j53zMQ5uEUKuujEBDA237ZirmDxDas1J58Abp7oQ09gTRMBW
        BIuFNK7sPmK4OAIM51lLNY4739w6Qs7SFEbwRlVo8A==
X-Google-Smtp-Source: APiQypLKTV5cjB5vRxRCgOZLGp0AAy54RP6broEU3Exdjxr6TLWJ/Uyf8QXKvgDLWdJKhr694p+jflla68cP66+UORM=
X-Received: by 2002:a67:e915:: with SMTP id c21mr1827147vso.165.1586428940514;
 Thu, 09 Apr 2020 03:42:20 -0700 (PDT)
MIME-Version: 1.0
References: <20200331205007.GZ823@zorba> <AM7PR04MB6885CDDD1ECEEAE7111C6201F8C90@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200401152635.GA823@zorba> <20200407163443.GK823@zorba> <AM7PR04MB6885EBF5DA973DA083EF0E6BF8C00@AM7PR04MB6885.eurprd04.prod.outlook.com>
 <20200408153037.GA27944@zorba> <AM7PR04MB6885C60315AC6D59093CC439F8C10@AM7PR04MB6885.eurprd04.prod.outlook.com>
In-Reply-To: <AM7PR04MB6885C60315AC6D59093CC439F8C10@AM7PR04MB6885.eurprd04.prod.outlook.com>
From:   Ulf Hansson <ulf.hansson@linaro.org>
Date:   Thu, 9 Apr 2020 12:41:44 +0200
Message-ID: <CAPDyKFo2zjh7UTcinOeiCxx86FJOQzhm=tQEdpTByiOTN=kaNA@mail.gmail.com>
Subject: Re: mmc: sdhci-of-esdhc: fix P2020 errata handling
To:     "Y.b. Lu" <yangbo.lu@nxp.com>
Cc:     "Daniel Walker (danielwa)" <danielwa@cisco.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Shyam More (shymore)" <shymore@cisco.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 Apr 2020 at 05:42, Y.b. Lu <yangbo.lu@nxp.com> wrote:
>
> Thanks Daniel for pointing out it.
>
> Hi Uffe,
>
> As Daniel reported, below commit introduced issue on P2020 platform.
> fe0acab mmc: sdhci-of-esdhc: fix P2020 errata handling
>
> And the fix-up for the issue is,
> 2aa3d82 mmc: sdhci-of-esdhc: fix esdhc_reset() for different controller versions
>
> It seemed fe0acab was applied to linux-stable for 5.5, 5.4, 4.19, 4.14, 4.9, and 4.4, without the fix-up 2aa3d82.
> I tried to cherry-pick the fix-up to all these stable branches, but got many conflicts except 5.5 and 5.4.
>
> May I have your suggestion from safe perspective should I rework the fix-up for these branches, or request to just revert fe0acab.
> The patch fe0acab is just for errata handling while the errata are hard to trigger. It is not strongly required.

It sounds to me, like a revert may be the best option, at least for
4.19 and backwards.

Perhaps from 5.4 and onwards, you can send the needed additional
patches as plain backports to stable, as they should be easy to apply,
right!?

[...]

Kind regards
Uffe
