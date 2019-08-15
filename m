Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8A48E7B8
	for <lists+stable@lfdr.de>; Thu, 15 Aug 2019 11:04:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730404AbfHOJED (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Aug 2019 05:04:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43765 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbfHOJED (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Aug 2019 05:04:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id y8so1569423wrn.10
        for <stable@vger.kernel.org>; Thu, 15 Aug 2019 02:04:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=OJ9Rn7AifguNlh+3sXkGL+NYioLLma1fdG6EnYR77iM=;
        b=dVNsCNuqRtE2Hagj8PdiD1Nv7f4UR2gqw/GwGPc8t4qKa1U9/Kw9uqL8evQBjbOiJJ
         Mg9iQI1XH/RJV1ZknV3o/3shtTwQk/v6MIFQkbR1mMq9K+5toKbkM9M39YUOwNr/IXfF
         +U4xxHBIJzvr08exjwnqw2jvI89eL7c7Ad2Jea2p9FIRvAJHdtsUUC+ap0MyQA0paKec
         j1l0URIm+1AdLb0zKTUAVILvn6f0zkFDawF62dvAU9enGz6hxP6So+2IOOtx+fkpNDHS
         bAazRnpa9CsxXeKANglL3iXzEkaAeLnZLNLc3u7e8ATV2i7DgLgn2poqkByHN9jM0JkQ
         Iiug==
X-Gm-Message-State: APjAAAVGIyld571Dgz/6wFbq0OTybLw3gTPS7u0H3u2ke/piSoCRLq2O
        XBs66I39nsfTVjxXHKREPTiOq9gvlkA=
X-Google-Smtp-Source: APXvYqyb2ifVbi1FkmMVb283kF/DTlYwP5lvFNgoEfo+C+98pqoRftQeX04bq6cIjYG84h6tcZMgQw==
X-Received: by 2002:adf:dd88:: with SMTP id x8mr4495877wrl.331.1565859841524;
        Thu, 15 Aug 2019 02:04:01 -0700 (PDT)
Received: from localhost (nat-pool-brq-t.redhat.com. [213.175.37.10])
        by smtp.gmail.com with ESMTPSA id t24sm759005wmj.14.2019.08.15.02.04.00
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 15 Aug 2019 02:04:00 -0700 (PDT)
Date:   Thu, 15 Aug 2019 11:04:00 +0200
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     stable@vger.kernel.org
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Backport 2a92b08b1855 ("mt76: usb: fix rx A-MSDU support")
Message-ID: <20190815090359.eevqqk3vt4dcrw3k@butterfly.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi.

I'd like to get 2a92b08b1855 squeezed into a stable tree since it fixes
the following splat in the kernel log when using an MTK-based Wi-Fi
access point:

[135577.311588] usb 1-3: rx data too big 2044
[135577.311689] usb 1-3: rx data too big 2044
[135578.166351] usb 1-3: rx data too big 2044

See also: https://bugzilla.kernel.org/show_bug.cgi?id=203789

The patch applies to the v5.2.x series without conficts.

Lorenzo, are you fine with this?

Thanks.

-- 
  Best regards,
    Oleksandr Natalenko (post-factum)
    Senior Software Maintenance Engineer
