Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9419A1F04
	for <lists+stable@lfdr.de>; Thu, 29 Aug 2019 17:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbfH2PZX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Aug 2019 11:25:23 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46652 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbfH2PZW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Aug 2019 11:25:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id p13so3236516qkg.13;
        Thu, 29 Aug 2019 08:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0mHHzudUkCQcPt1wULA8owTufUJouDmPGZVLzU80PzU=;
        b=iNyTMQgs2x8237GjAk5cXaA6wwhNWCidgqk7C9GHy4B9loY4lge3i7l9CMEacA/w6z
         hnMuvvia3nVOvXdNAoCE7AAUMGuAk7Bv5ozGXX/Zefj9kvczbxBZH6eT9Zz6IUUIQwmS
         xmXUPySsfM4paM9fpRAogQsOhkNZWIdme6pGWl/wi5Hd46kOsY3JbBhYH889OuGLl1NE
         k0oVXYb4gmvZlnopB9wVLFuuipICjJepQbLHlqS18u90HGy8ls1eIYbySkS2tE7pubIX
         Zbsogn6lAxmjeFttsEqdzHxSr1rxy6Wr5X1QJbHECEMNoE89ZYJfxdXbZ2ap9hJVTYyO
         ljOA==
X-Gm-Message-State: APjAAAVlfghpwOtOkTM+UBcHMNChGpCtD/ljb7QSJDbm7KxVPfFMLDqj
        LeDpdpHd439ZbaRzQtwi8PiYbwg3QXhGdaf6Jsk=
X-Google-Smtp-Source: APXvYqxse9IwiB3NzD3hX4SWgAcDhZXn2uWJ0Ujx5Ucz70UYZnwwtgbJfuf5IaBrajYl1n7GZZiZUTBzaq+gWzCJ3g0=
X-Received: by 2002:a37:4b0d:: with SMTP id y13mr9983002qka.3.1567092321745;
 Thu, 29 Aug 2019 08:25:21 -0700 (PDT)
MIME-Version: 1.0
References: <5D562335.7000902@hisilicon.com>
In-Reply-To: <5D562335.7000902@hisilicon.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 29 Aug 2019 17:25:05 +0200
Message-ID: <CAK8P3a1t20bmJxfijrNWnSGoR8BOvUYGxDaoMUTV78Lp_LPi4g@mail.gmail.com>
Subject: Re: [GIT PULL] Hisilicon fixes for v5.3
To:     Wei Xu <xuwei5@hisilicon.com>
Cc:     SoC Team <soc@kernel.org>, "arm@kernel.org" <arm@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Olof Johansson <olof@lixom.net>,
        "xuwei (O)" <xuwei5@huawei.com>, Linuxarm <linuxarm@huawei.com>,
        John Garry <john.garry@huawei.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zhangyi ac <zhangyi.ac@huawei.com>,
        "Liguozhu (Kenneth)" <liguozhu@hisilicon.com>,
        jinying@hisilicon.com, huangdaode <huangdaode@hisilicon.com>,
        Tangkunshan <tangkunshan@huawei.com>,
        Jonathan Cameron <jonathan.cameron@huawei.com>,
        Shameerali Kolothum Thodi 
        <shameerali.kolothum.thodi@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shiju Jose <shiju.jose@huawei.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 16, 2019 at 5:30 AM Wei Xu <xuwei5@hisilicon.com> wrote:
>
> Hi ARM-SoC team,
>
> Please consider to pull the following fixes.
> Thanks!
>

Pulled into arm/fixes, thanks!

      Arnd
