Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27EAE412AEF
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 04:02:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241879AbhIUCDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 22:03:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241832AbhIUCDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Sep 2021 22:03:16 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 146BBC08EB59
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 11:13:38 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id e16so5597296qte.13
        for <stable@vger.kernel.org>; Mon, 20 Sep 2021 11:13:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pvo6MEzKPqvSnqMuVSEU2j4Wc9oFmpkpJEqXAbkOyyM=;
        b=D2Zn3m+Po3J2M65Ciea5U6ug8D3yclkghX6docLBBmmRuzBib2C6FKhJnFHTTYGrKx
         zeJSrdylCQFeIYilxcFlb5k17oHOTp8XXX961fO0hDRCqOrMiWCe6kxlwDvxQYM81HIq
         NKKQlzETS+kJ6YElb8n7t9FomlfrnpkC6JpM0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pvo6MEzKPqvSnqMuVSEU2j4Wc9oFmpkpJEqXAbkOyyM=;
        b=bj+iWqktaW7ryu5ffs3PUMSXAypPEoLgw9gVmR0a9zWpAOyHtewrfMt0Y8pacgsGEo
         O6o/+F9zV4HkxOtJTEw8IYZl68unHZOi5TAohd5R5kpp9dH5tEG54gBhdo2JCYIQeSov
         BC44hYDmBgDbvT7wQK7GGh3i2vcpxDiOANPLz158WE57C94Tr5qlZYM1M9HushpZ6KDs
         jAOLoFyvd0qT5/yyLnTQB+qbQxrGlsqK+OkC0+bpS092pDbgEp5ZFuW//LwcbCHdsmQE
         XjHccCPPED8Eo/w1CvJHmrw0oppSotU9MJY3Xq/G3i+fwKHwNSITaKDhi1F9+4DOy1EZ
         E9mA==
X-Gm-Message-State: AOAM530nwwB6B0rzfq0QSSb0UZa0H2E64O+EzpbHTUom8gL0dmQNYzDo
        r5RKrj4qQEPHhuFOX4tujkbNLc9/5CaUvegdkIiVNQ==
X-Google-Smtp-Source: ABdhPJxv3M4Q3DyA/8nV9kXnhwWl4Jp/tLX6DzdAtOGhsSMaVriT0Tvl6jC6gMjFAotBRgBZ9aRtyaV6+FYHNi+U33Q=
X-Received: by 2002:ac8:5d91:: with SMTP id d17mr3609906qtx.18.1632161615279;
 Mon, 20 Sep 2021 11:13:35 -0700 (PDT)
MIME-Version: 1.0
References: <20210920163921.633181900@linuxfoundation.org> <20210920163927.070105317@linuxfoundation.org>
In-Reply-To: <20210920163927.070105317@linuxfoundation.org>
From:   Michael Chan <michael.chan@broadcom.com>
Date:   Mon, 20 Sep 2021 11:13:24 -0700
Message-ID: <CACKFLin7kZFio3Tj+2M7Juq_Vxrfw4KPPkVnE0rtm-hBgQK7nA@mail.gmail.com>
Subject: Re: [PATCH 5.14 164/168] bnxt_en: Fix possible unintended driver
 initiated error recovery
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     open list <linux-kernel@vger.kernel.org>, stable@vger.kernel.org,
        Edwin Peer <edwin.peer@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 20, 2021 at 10:35 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> From: Michael Chan <michael.chan@broadcom.com>
>
> [ Upstream commit 1b2b91831983aeac3adcbb469aa8b0dc71453f89 ]
>

Please include this patch as well:

eca4cf12acda bnxt_en: Fix error recovery regression

Otherwise, it can cause a regression.  Thanks.
