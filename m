Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 594F31B00F6
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 07:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725815AbgDTFYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 01:24:23 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:33931 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725710AbgDTFYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 01:24:23 -0400
Received: by mail-pj1-f67.google.com with SMTP id q16so4308105pje.1;
        Sun, 19 Apr 2020 22:24:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=K1EufJhoKXAZrVxjekdMJrvgmrsL3ufW1zU9l0LvEYY=;
        b=HVeKQHzxiuxv+qQwaXjPA47AOpTsyCWdwIHlUUQK3mBWn7VpgD0mafpO6j4iB4mrIO
         M8WSFhOMRJFkzaVHyboFFYI1BO0FaFOonH5xymxHLoy+3oJlnCf7egx4TqUmmhogjFrt
         nLI64L7C/9F7d0gzJGR+oNcI7oYdM8EZbF9eoDhRnntI2nroQqda5nupyyoBX7HV4/5P
         zcS/VKuOzETRn61FcUkVfEPGuKwlc/XUt7x4JkTIMqOp8TCT/oGrtW7u8Cm+eRCYdcTM
         h07Y11qlUSOlUYogx+BNRVVZcPMKpBs4jFy6JDy91eBBOITQkY2VEN0J2z1ZsbupUFcF
         61vw==
X-Gm-Message-State: AGi0PuZ38S9ZJ+opDQzLMZz4IItS5SiZMgRgOkx56CLAObCHmOZGkkKS
        +gk9itxZKjtP8N/g237sfQ89gC24
X-Google-Smtp-Source: APiQypKGL2ACEgr6lcqS/nTfLQ/3dlQmBWrZf/B68lXNXdC97qK11XT6Prr3sMiFI/6YeYSmGA8OEw==
X-Received: by 2002:a17:902:8b82:: with SMTP id ay2mr15735468plb.285.1587360262734;
        Sun, 19 Apr 2020 22:24:22 -0700 (PDT)
Received: from sultan-box.localdomain ([104.200.129.62])
        by smtp.gmail.com with ESMTPSA id m3sm25197383pgt.27.2020.04.19.22.24.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Apr 2020 22:24:21 -0700 (PDT)
Date:   Sun, 19 Apr 2020 22:24:19 -0700
From:   Sultan Alsawaf <sultan@kerneltoast.com>
To:     Chris Wilson <chris@chris-wilson.co.uk>
Cc:     stable@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] drm/i915: Synchronize active and retire callbacks
Message-ID: <20200420052419.GA40250@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
 <20200407064007.7599-1-sultan@kerneltoast.com>
 <20200414061312.GA90768@sultan-box.localdomain>
 <158685263618.16269.9317893477736764675@build.alporthouse.com>
 <20200414144309.GB2082@sultan-box.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414144309.GB2082@sultan-box.localdomain>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris,

Could you please look at this in earnest? This is a real bug that crashes my
laptop without any kind of provocation. It is undeniably a bug in i915, and I've
clearly described it in my patch. If you dont like the patch, I'm open to any
suggestions you have for an alternative solution. My goal here is to make i915
better, but it's difficult when communication only goes one way.

Thanks,
Sultan
