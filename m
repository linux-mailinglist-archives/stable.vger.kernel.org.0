Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED27225813
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 09:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727065AbgGTHDM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 03:03:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgGTHDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 03:03:11 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758EFC0619D2;
        Mon, 20 Jul 2020 00:03:11 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id n2so11997752edr.5;
        Mon, 20 Jul 2020 00:03:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1SXLMIBfdlyWcAZDCzCiZL8pBGjqpEdAnfRcPKA6Z+I=;
        b=RkIeuIPVUEmRlE3Yg2c88oYDRAI99bhPZIp2uz0Ygc9M+y6/06ZcYgfjndg0tBoWw4
         zAwhwMaJI09dCGSwkN2UrCeEsDHtr8AOlxxPjOOtYNP4ugvr7p1/czr4KfkOnJve/3rr
         3YUZ+a3QOJpQ16CNoqRcZI3gwnd5vdnZZZjHb/dNY5PqyFT+RczJy9oNCvm2XdrUGrDd
         ThI2UuGOWIu8mqd1J1Mqff/GEMYoHAIO55yp49kzuAlzgFGLTRn50ClcFW/+8+/jPhe/
         3kI8huBnqSiAgi2A3C+qpEepCuGheTz0CjoEa0t0crBsq3pCRbcn6rm7ZmRQaT7VtZjp
         /gGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1SXLMIBfdlyWcAZDCzCiZL8pBGjqpEdAnfRcPKA6Z+I=;
        b=aC7hTmktBzcSbWWvSztWu+f1GH+5VYlIylPWNCfXySXalYp7p860xoaT68ZYi3LX4K
         pMLxUhMem0NYd659kLfjerkmWhaG30ffXFjKfw123fZlQaxne1xaVe2PvlX9OGkkOYJ7
         30C7+yBI6C/bVJ30qNb0YsfRuuICqLvfu9/tKvBXlcnEDroMYm3i1bhGc3upfXuRIBgh
         U18T3CIlNq/DARweCeVKvcP61bCSxnp45SkR6DLWradCkUdwkkeMhqAYbyWWNLRad0fP
         lyiRfvbItNVJSjyHdPWjy8DBrA88yKZVb+fmvlpn7rcyEqanYE3pDnOLIvFg2qeLXLgs
         knIg==
X-Gm-Message-State: AOAM532D4M/Di91mB4Z+a2zwLLMuAbFFtEhknbF2W7sJjRQfnQBid6wZ
        wcjtNCxMN94Vr6jGcF4tJB/cel8vwOZCB2eDz4U=
X-Google-Smtp-Source: ABdhPJzLszhKqRQKQT/n5dJhkrUH9K4aJ/xq9j1kS4fmR1NmGEntDUdFtIJFzLhecEhjwaj8gnY1UvxGm0oy/GZmV14=
X-Received: by 2002:a05:6402:14c1:: with SMTP id f1mr21005708edx.342.1595228590248;
 Mon, 20 Jul 2020 00:03:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200717213510.171726-1-kwizart@gmail.com> <20200717215304.GA775582@bjorn-Precision-5520>
In-Reply-To: <20200717215304.GA775582@bjorn-Precision-5520>
From:   Nicolas Chauvet <kwizart@gmail.com>
Date:   Mon, 20 Jul 2020 09:02:59 +0200
Message-ID: <CABr+WTkJ8jZDkM_=-LYxpbrqrsPEb96YBRJvBjR5u+0Ck9R4CQ@mail.gmail.com>
Subject: Re: [PATCH] pci: tegra: Revert raw_violation_fixup for tegra124
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Manikanta Maddireddy <mmaddireddy@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-tegra@vger.kernel.org, linux-pci@vger.kernel.org,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le ven. 17 juil. 2020 =C3=A0 23:53, Bjorn Helgaas <helgaas@kernel.org> a =
=C3=A9crit :
>
Thanks for the quick review. I've addressed all comments and I've
resubmitted a v2 to
https://www.spinics.net/lists/linux-pci/msg96863.html
Unfortunately I've missed to modify the [Patch v2] tag. I hope this is
fine. Let me know if I need to resend.

> Is v5.4.x really the oldest kernel that should get this fix?  It looks
> like 191cd6fb5d2c appeared in v5.3.
The commit was introduced in 5.3 indeed. I've added 5.4.x since it's
the last maintained kernel from long term branches.
Now I'm using the Fixes: tag, I've dropped the version of the kernel
for stable as it seems duplicate and less accurate.

Thanks.
