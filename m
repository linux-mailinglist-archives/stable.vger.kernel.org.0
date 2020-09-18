Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A36326F656
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 08:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726481AbgIRGxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 02:53:09 -0400
Received: from mail-lf1-f65.google.com ([209.85.167.65]:41809 "EHLO
        mail-lf1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726427AbgIRGxI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 02:53:08 -0400
Received: by mail-lf1-f65.google.com with SMTP id y17so4946344lfa.8;
        Thu, 17 Sep 2020 23:53:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=jEIokPWY8McXPGxPjFui/VeUF3vCcShRe9TmH70vfVc=;
        b=YvUPjxfekIMCDK7iM6OBhdEw/OwZcMxfdm6hraLyYa6yAduEzCPUPPBImeM1yxpvxd
         yDrchSA0TFBG5/Yg+Bzzpq+niJ96aFPwq6V2g9ljLcmWttMnsLnSaiMg3AfcTRpFxblm
         UljLIqgzoiDAvbh6EZ2D6X1xd7WGI5NqkZ2uEEz8ZqdYYLZDitlj72FnxMznotkqbeBM
         shwCmBMNsvgHLPu4RY9b6pIQbIVcuV5NNoLqVkUNBVS5yMzOur9TPsIqU1NtAhTrMGRC
         kBbl90QkQLuy5IiVPsGQh+cSD7I/GjusxXLASnDRmRp+m9j3fCYCbZtZUi8J5wv1b1H0
         ECeA==
X-Gm-Message-State: AOAM533hr8MkWHySnjr7RJaVtg3DQFCtRrW8hxkMKFKFpIy/XRvZgAgB
        6dy+9lhzV/lWYGQ6x0fgPVLuqYbXMng=
X-Google-Smtp-Source: ABdhPJyuh9HtxeBxunoebr024x2ZU8qQdRsKa692WK3UGnrpTGSSOnU8hBPIt0CDHrPpFYpQtkk9Og==
X-Received: by 2002:ac2:5217:: with SMTP id a23mr9739542lfl.509.1600411986135;
        Thu, 17 Sep 2020 23:53:06 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id u14sm396413lji.83.2020.09.17.23.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2020 23:53:04 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kJAGS-0005pO-6J; Fri, 18 Sep 2020 08:53:00 +0200
Date:   Fri, 18 Sep 2020 08:53:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.4 041/330] USB: serial: mos7840: fix probe
 error handling
Message-ID: <20200918065300.GA21896@localhost>
References: <20200918020110.2063155-1-sashal@kernel.org>
 <20200918020110.2063155-41-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200918020110.2063155-41-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 17, 2020 at 09:56:21PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit 960fbd1ca584a5b4cd818255769769d42bfc6dbe ]
> 
> The driver would return success and leave the port structures
> half-initialised if any of the register accesses during probe fails.
> 
> This would specifically leave the port control urb unallocated,
> something which could trigger a NULL pointer dereference on interrupt
> events.
> 
> Fortunately the interrupt implementation is completely broken and has
> never even been enabled...
> 
> Note that the zero-length-enable register write used to set the zle-flag
> for all ports is moved to attach.
> 
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please drop this from all stable queues. As the commit message and
missing stable-cc tag suggests, it's not needed.

Sasha, please stop sending AUTOSEL patches for usb-serial. I think this
the fourth time I ask you now.

Johan
