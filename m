Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9316C43E4E
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 17:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731727AbfFMPsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 11:48:45 -0400
Received: from mail-yb1-f193.google.com ([209.85.219.193]:46694 "EHLO
        mail-yb1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731728AbfFMJSV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 05:18:21 -0400
Received: by mail-yb1-f193.google.com with SMTP id p8so7530919ybo.13
        for <stable@vger.kernel.org>; Thu, 13 Jun 2019 02:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=t0dHns27HFmxWDCAb9Jm++Mc8LpNUfnQOnC9cpmyGSw=;
        b=UANnHxtgRBQ29wuYyyaqi7fPa1xDo/t6Ar45TfXkMhjZd6xaDuq44hLJ/ZHrybHXcT
         MO1vOOdMrVUc9GIwIZeEQ8KvKJoMypFPPXh2E2Z9C2ih+TNNj1vicizRkYxed3EJXfUF
         ZUfrBAg05w/sPJxRwMmovrb3wujaZhy9mIr/EOO3v4dg54Vfc+VBQzPX/dSRMjPwcfIi
         mEu9euFNbeJSwDfMej/JenCdUOMHCAEsOeaoyJB6XYyHM1pzZjjxi0HcKt4SNSCHMVmk
         XbEfsJy5I1Agp7hkh6rO70IO8VjizjrrDrSJxMZweu3FMrteT5ntm+5qu7zeFe1sp8nR
         C5PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=t0dHns27HFmxWDCAb9Jm++Mc8LpNUfnQOnC9cpmyGSw=;
        b=S3+Z7WNxBwtLK/VHW4P27L3n9kE0gSrwUurXCvmVaQ3cLIA2lvbjopjIq5bJaDto+B
         toaVbZm/K+I+tIuWy5ZhhwYBz/RcYFuHVo+jjnhjaXUssn29rymP/EWY2Gl+kO2tUbkx
         XbHVxjNIkGs0xrBIeYLAxV3wPhWrQEO3I6DkfEZCiKsj5iYX7+50nxNllsp7pnXSRAlG
         GT/jQVfuDtWOn3kL4PLA1ake9nWNi5bCkhFhOKhPjISz7MaAMgaBymiLGw7TfawBdbsb
         cyeNJ3YxZj4OaS0nXSwmO812cUZh7MZT8fnqTsH4WHYw69R/9ZHUmt7ydtvkhPM046TP
         WLHw==
X-Gm-Message-State: APjAAAVclx28XrtxdUKckc4PXHP29H5lt8nD3o0uptsfVC2KCLAHKE1o
        j1KVrXeua3Lcr79X6GWOcA5rRiVe5pO3UQOS
X-Google-Smtp-Source: APXvYqwBpvLQDsuhL+iUb2TdIrLsAqF+AKXE1OsgryysOBdP+/hZ2Y0Ongjhea/62jtr+hsdGJjiOg==
X-Received: by 2002:a25:d407:: with SMTP id m7mr40723607ybf.409.1560417500448;
        Thu, 13 Jun 2019 02:18:20 -0700 (PDT)
Received: from [172.20.10.3] (mobile-166-172-57-221.mycingular.net. [166.172.57.221])
        by smtp.gmail.com with ESMTPSA id e77sm708106ywe.23.2019.06.13.02.18.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 02:18:19 -0700 (PDT)
Subject: Re: [PATCH] libata: Extend quirks for the ST1000LM024 drives with
 NOLPM quirk
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-ide@vger.kernel.org, stable@vger.kernel.org
References: <20190611143259.28647-1-hdegoede@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <96b954ce-0c1d-7639-8b73-5dfc04b772b3@kernel.dk>
Date:   Thu, 13 Jun 2019 03:18:15 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190611143259.28647-1-hdegoede@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/11/19 8:32 AM, Hans de Goede wrote:
> We've received a bugreport that using LPM with ST1000LM024 drives leads
> to system lockups. So it seems that these models are buggy in more then
> 1 way. Add NOLPM quirk to the existing quirks entry for BROKEN_FPDMA_AA.

Applied, thanks.

-- 
Jens Axboe

