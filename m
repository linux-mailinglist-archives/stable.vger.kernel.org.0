Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5180F1A736C
	for <lists+stable@lfdr.de>; Tue, 14 Apr 2020 08:13:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405711AbgDNGNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Apr 2020 02:13:19 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42544 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405818AbgDNGNT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Apr 2020 02:13:19 -0400
Received: by mail-pl1-f195.google.com with SMTP id v2so4279289plp.9;
        Mon, 13 Apr 2020 23:13:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5vYUlFRrmo48Z6uIstdlFK2RpwU8zu6bS3VJnypHQaI=;
        b=mBnLhLVfDuRNO/yQBsHzauLqLCTTAxog0/kg37PXG6pACFstEuH3Q9j9vCuQ3tV2jG
         HGiTEAl93FQbGxFN9m8UPrQsb1vboD6FyZCvm4vhHwdwe0A0Wvg3OTTeyta5lUm3mYeN
         4PZLgvlH3k5kFwm1rYBys+551KoQQQlw3QWKfNIh4FZzHb9VolGC7I2fLrDGB7fsp+YQ
         6Ta3hhC/s5gk+mxFrNWQxWaoXks9i5JFOCy5IygnKUk20v00p8q9+6WPw618kG5pP0Jg
         UxZN7TlBVFVvUbHB6z4lwbhrZSKb0BNhkV1DDM0n6Su7m4Fll9DfYBqziWUwUYqsA9SP
         wOzw==
X-Gm-Message-State: AGi0PuZuPX3e9/HqIddg1HJwynYXhJ7J0GnKndh0LxPp5yfOtaWMs+el
        bYtYs1D7sVw8DzspwrgnR9s=
X-Google-Smtp-Source: APiQypLHuOqX8NGAjwM3Onpv7qlpUvNmBWIvQMcbKF0BZVkrwkXbgqqRtvcb5m94Vum2lGnSjxaFOQ==
X-Received: by 2002:a17:90a:d0c5:: with SMTP id y5mr7451458pjw.26.1586844796676;
        Mon, 13 Apr 2020 23:13:16 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id h4sm9455050pgg.67.2020.04.13.23.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Apr 2020 23:13:15 -0700 (PDT)
Date:   Mon, 13 Apr 2020 23:13:12 -0700
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
Message-ID: <20200414061312.GA90768@sultan-box.localdomain>
References: <20200404024156.GA10382@sultan-box.localdomain>
 <20200407064007.7599-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200407064007.7599-1-sultan@kerneltoast.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Chris,

Could you please take a look at this? This really is quite an important fix.

Thanks,
Sultan
