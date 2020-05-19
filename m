Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 702C51DA006
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 20:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726348AbgESSxZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 14:53:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726059AbgESSxZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 May 2020 14:53:25 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7087DC08C5C0
        for <stable@vger.kernel.org>; Tue, 19 May 2020 11:53:25 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id f6so262163pgm.1
        for <stable@vger.kernel.org>; Tue, 19 May 2020 11:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GhyTpRQ/WCpKEr3XKAYXoKZHCKoIGxPWKo69x2Kd060=;
        b=vBDh30anCQjvr+xkJgy2MTP+UJHSgNCw8MQmABWuLdm9T++6bBdA91LwWcMtL0yUlY
         FRpljIXcA/9w48gb6LSilKw+CVTdcu4KPZxq67qWcJYePKDuqsQoROsa4AE+J0+cDGHo
         Gw6FxagvhvDczHSzFPFcmLsbhX9fwwG2qavocaayXQQ0acPFx70LrOsTTOjNCYK4rZIw
         XJ8DOjIHTdjLXcFjmGMS3Vb2PYX2fSgvY62/vf+mdQl40J0AO0y20OwEq8xHBWNkE7lL
         SJGkRJXe6QTIuOmV9eIuYvGPnssLRaMqaqFi0OPaACznghuYtyowi37SgR+D9bgCVAog
         JVqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=GhyTpRQ/WCpKEr3XKAYXoKZHCKoIGxPWKo69x2Kd060=;
        b=UPTZlL26uym2tAzTvMilm5KPvr5di3QPEzRmNYn3iYlkBtQ4PGV6eINFAtPd0ocxmb
         GbYZa5ekH9JO+PmwXTfwLBWPMpIKkga2JaXEgPb3K2rcx6EAAMZPSIIi86w9X1fh8eGk
         1RyR/me7gRORkvN+pvkjwXedTpo01zeXZKCLcQl4b104xP5Eu8NcQkuYaoqvVB+mP8yj
         ucIxLPlgL7boK2dvW5zuSnJr2iAzawMc1MwH4/tCIv9aKoZwA87yGhyWZqhzWRYeKKUL
         DtduM+T3xL+X69/h5DnonBTDM3fmQ8q7jBN6v3owrRZ8iBBThVvAUL0SZXTt/HZ9cCkV
         XuRQ==
X-Gm-Message-State: AOAM533oWnoMG86XoqXiwGR2yO841oQFTtM1O4zZb6HHnzlNtnc9Kv8l
        /bdEkZAEPs4g9p3l+emOi2XxHVvl
X-Google-Smtp-Source: ABdhPJxcMoSli5uA9YHk1d8Zc3lJSYhVhz+CJGqyuKhR/V/PNrk1KKB/w6ZaHc7HhH5LbV89WmtKLQ==
X-Received: by 2002:a62:4dc3:: with SMTP id a186mr453481pfb.269.1589914404752;
        Tue, 19 May 2020 11:53:24 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z29sm193580pff.120.2020.05.19.11.53.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 19 May 2020 11:53:23 -0700 (PDT)
Date:   Tue, 19 May 2020 11:53:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Please apply commit 629823b872402 ("igb: use igb_adapter->io_addr
 instead of e1000_hw->hw_addr") to v4.4.y/v4.9.y
Message-ID: <20200519185322.GA67531@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please apply upstream commit 629823b87240 ("igb: use igb_adapter->io_addr
instead of e1000_hw->hw_addr") to v4.4.y and to v4.9.y. The problem solved
with this commit has been observed in chromeos-4.4.

Thanks,
Guenter
