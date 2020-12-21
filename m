Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 564222DF9F2
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 09:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726083AbgLUIb7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 03:31:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726061AbgLUIb7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 03:31:59 -0500
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48718C0613D3;
        Mon, 21 Dec 2020 00:31:19 -0800 (PST)
Received: by mail-qk1-x72f.google.com with SMTP id 143so8118578qke.10;
        Mon, 21 Dec 2020 00:31:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=agufzdof60zlUK6ABtjejQ/iy/4CzpBaSupw0iZ8+Ao=;
        b=MXQ3N2DmSnxCSpoPhobcjAyP4XxNwT+rpXEgC0H933setdseNhZlYyaIhwKDL+d2qT
         KrOeaNUokPnIo0B8A4EnpupRD1bV9JQ5PnpjauFbNVKzc1vgWAkvo/ZEQDau/CXQBaUz
         9dVJgaPFOQ1GPg7LjqKcNXQCP3kbOu6hGmLXBQyq2EMtAHR+gVWpJ+gGYKsJgPsiwo5H
         IPhErGPgtyZ+q2d+v+5DhcQjQsxurtqBvhClRO+Z6iRPRN1sDQwOqSV2SC6ucTHyyBzq
         jn9vnwwxfFUWbyd1ANDgPtOp2GDXjsOC0k60o5cr4IwEjbi6pvywuV1WLCBwoyXyllrR
         UPqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=agufzdof60zlUK6ABtjejQ/iy/4CzpBaSupw0iZ8+Ao=;
        b=Zp5XWrZM9a1i8YRS4eHR4MAUG4Q/Cp8hmcdX3cIJhycq4MEdPjjyoW1vcJqcmxEI9i
         3Xh6bIyXdiUIXF+5QfwzdGaEZhahYRftnuw69ZbVx9uKSGbJOZ9sCFwC2hzEbvXS64/0
         iec3duYLN3QKSs5nhpPQo68vV8+6dANDe9Eri0CNBCo1a5ZmeW9YyVgWimajM+t7wZv3
         BK0n2SDMQsQ6A6ce3qSY7WbWlx6aG6xi8h71dx/C+CXOZhfRRM6lZQCVhAPlsuWz+JuU
         5BwMLCyYnmlQl1Dd090vkKbGCdXOk9voOfz/BWYoUifshpdaiHcjKcNeM8Zs4cLUEFWM
         MZpg==
X-Gm-Message-State: AOAM530ar6+jwHsrvkDY7mwSebweAeMUZpHe7kEmM5NpepfRd/sQEJaU
        k6NL4POPP5StlFjINlpLUtS2yBr2dA0HSr5kDFg=
X-Google-Smtp-Source: ABdhPJzxqKkjZAYMchhCMzQbWEYHatHt5NrejE5HIq/Nv5PqZQV/Ibcm8UT6rRlzDnMfw7GAPAfxrTK0X84Ap13KolE=
X-Received: by 2002:a37:8202:: with SMTP id e2mr15774000qkd.412.1608539478224;
 Mon, 21 Dec 2020 00:31:18 -0800 (PST)
MIME-Version: 1.0
References: <ea52c20eba8ab65ce1e716fe8627a1938a354268.1608491503.git.asml.silence@gmail.com>
 <a195a207-db03-6e23-b642-0d04bf7777ec@gmail.com>
In-Reply-To: <a195a207-db03-6e23-b642-0d04bf7777ec@gmail.com>
From:   Josef <josef.grieb@gmail.com>
Date:   Mon, 21 Dec 2020 09:31:07 +0100
Message-ID: <CAAss7+rOO-scU0Jdj6D+=EhTj6T8yUgo2hUKEV5-YXZ3Rpq2ZA@mail.gmail.com>
Subject: Re: [PATCH 1/1] io_uring: actively cancel poll/timeouts on exit
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>,
        stable@vger.kernel.org, Dmitry Kadashev <dkadashev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> Josef and Dmitry, it would be great to have your Tested-by: <>

my bad, it doesn't work, it's related to this thread
https://lore.kernel.org/io-uring/31cf2c96-82a5-3c21-e413-3eccc772495c@gmail.com/T/#me3b958c51320f999384d7a05a958237b29146486

--
Josef
