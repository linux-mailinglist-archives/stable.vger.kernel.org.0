Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E20E6369C75
	for <lists+stable@lfdr.de>; Sat, 24 Apr 2021 00:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231881AbhDWWLm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Apr 2021 18:11:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbhDWWLl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Apr 2021 18:11:41 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FC4AC061574
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 15:11:03 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id u16so33280318oiu.7
        for <stable@vger.kernel.org>; Fri, 23 Apr 2021 15:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tM4eTDGHytEbca5/btYjj8+cL1VK8pRD4FClAIECdeI=;
        b=l8/f838Ad4CyTaOXOcDNbNGTpuQFPY0wfAQ8H7eyGXoZyEJv89m9hRHWuPv71aM6h3
         ftw99tEGz34GlJLOPEkVGebuPHbbvLXi6AAvCW6rOLUd7SP33Uk9EnjXrLmVZVYn9MkJ
         jafE26ibiFBN3I2QZGBRfU6MqB/MVP2+5aemPcvh/daVYR/sUi1XX2q8/nhyC5sQQtzh
         hei25sO6p/pngQIf9MvxrIZWx/ERvZLQ430ouT4LUicwVDVIiHukZscG5Barq1nds6pO
         g5sryysPUfdvu1hGqQ20KF247yiDLPUvkTebm3GAi4/vx2w/n/yoFqCULjMChAzmvoSc
         l8xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tM4eTDGHytEbca5/btYjj8+cL1VK8pRD4FClAIECdeI=;
        b=osRaljX0WnfB6sa4GxbSH/Tm0usZf4TqzBwVuhTRPs1aIv9MpeJ4Bmu+ii2hzPA3wS
         ScdO94+iqchDp6QLPpsSzYCdzTTEH0WlkRB4KnXzaKLem24KdWXFm/MPzEGIMTIkXauo
         wZe9dNhORS93uBDbbTaLq3qR3Y1dkPeKYE0fieRGLvu2lAF2c4K77ILBK2G9Jwno88cQ
         BM6/xYUVEcMFLLoFIVmeAaV6GMPhJXPQPRT38/LGYcq6cKUGc9mFqphxKJWF0FaTnMBQ
         LsRggRdOyNJAX9vub9PVccKPvd2d7D9pcs3xybsXtUcdVMPFAxZSf8ShrTQ1ZfCr7OMN
         1t0w==
X-Gm-Message-State: AOAM532rQJ2BSH9E/0sVNgTzqtyo4w9AbmFo5G7EPss+yVB9C8QWtmAe
        ioEnPIohNvhUzvl/vsEK5jLmMD4ZlIE5p2RNBKWeICIqLwg=
X-Google-Smtp-Source: ABdhPJzRRhSfbsCXInT22xsgnJQrnMZfMoqWX4K+Gcdg1oRY/myIa/no8C4xfZewERDYMrkF31LumGg6fObKVcvW8Mo=
X-Received: by 2002:aca:3744:: with SMTP id e65mr4365875oia.63.1619215862860;
 Fri, 23 Apr 2021 15:11:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210405210230.1707074-1-jxgao@google.com> <YG2q6Tm58tWRBtmK@kroah.com>
 <CAMGD6P1OEhOXfFV5JpPfTjWPhjjr8KCGTEhVzB74zpnmdLb4sw@mail.gmail.com>
 <YILkSsR4ejv5CraF@kroah.com> <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
In-Reply-To: <CAMGD6P2gUpUuX5cdPi1Q0nqRFmsBPctUR+hBt+DnPK+H4jHiiQ@mail.gmail.com>
From:   Jianxiong Gao <jxgao@google.com>
Date:   Fri, 23 Apr 2021 15:10:50 -0700
Message-ID: <CAMGD6P1DNoYFm4p8MQjuv83L16B+RuZCUREsO8hA+8Z7uUDW5g@mail.gmail.com>
Subject: Re: [PATCH v5.10 0/8] preserve DMA offsets when using swiotlb
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, marcorr@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+Marc, who can help filling the gaps.
-- 
Jianxiong Gao
