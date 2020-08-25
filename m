Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B841A2510B4
	for <lists+stable@lfdr.de>; Tue, 25 Aug 2020 06:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728377AbgHYEZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Aug 2020 00:25:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726619AbgHYEZU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Aug 2020 00:25:20 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D7FDC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 21:25:20 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id v15so5918458pgh.6
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 21:25:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+YsbixkNJbHl3U/j4h1R2QFBhRmHgyNCld/y8hVT0zM=;
        b=SqHJZ4q68uvHJEj1tqtBAPUefNUjIw5M1sYWPucazBAvrgMHSzQCgFi2hVNEBLGF1B
         rhntEosFuLtf8eCkSZzKxzNVAsgpAMkwL1JUJJhUdpGufg1LkkcjjWeGyhS+3DJSsn7/
         vWmfC093A/lLXKu1pDHpU9Ez4WXoU3YoHk8RFEilg48Ed3AyiTNtbbjYYaEg25OrUaPB
         eoSqKC61b1e3jx4rY23vbx91PYuEyuIl7Yfm5wZ85X42KVXxCppeDg4VFToGnTMWD7Of
         rTCPLanfINM95d5c1kbLayG0NFf3Pt7u9YEzItir7CC3miWHu2tB/8wWdrrt34zbjn2p
         XyxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+YsbixkNJbHl3U/j4h1R2QFBhRmHgyNCld/y8hVT0zM=;
        b=GprAOECTYuLcjmpUK7Fa81ffeSAbwFL6OSXNp/EwemWv9Ypup0DK4ImptV6l317HrE
         Qq2+Uj1trd/q6VenqlpB08xLgvRSddst87CiAQ3czLy6RtLxUmdqONNpU3tSeLGKtv3y
         BbVch3d/3k6GH331aV/OOldalSg7xeeNDwydzO19WONbRrQ697zWumrNv28CDwOTmiz8
         njNUXbb4zDDXz4hpDJ32tUcui5AN5MyCDB35vddN7gTLWn3bDAk1Nv1mMAq0mTPYeEt+
         6b4HPYrGPax/L7nrs8tsLTfUvZWaTnvndFegFS/dUGouxyYUi6YHtSYjx4uI3F8p+SUH
         6stg==
X-Gm-Message-State: AOAM531lXfo4nqpcoJplu1DleBCnPEanxpbRKacHt3B74UBU+5/JRhbN
        P57JxjhN3IiKNGnggDWSs8bZjQ==
X-Google-Smtp-Source: ABdhPJxUihmxgAUmEVRqbbCBcdXaWxS2Z8oQCFSsEy4g0DkFtCAJSO6hXu7wEkWdKXJS3+vV31qosQ==
X-Received: by 2002:a63:413:: with SMTP id 19mr5627102pge.310.1598329519767;
        Mon, 24 Aug 2020 21:25:19 -0700 (PDT)
Received: from localhost ([122.172.43.13])
        by smtp.gmail.com with ESMTPSA id r14sm5581804pgn.83.2020.08.24.21.25.18
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 21:25:19 -0700 (PDT)
Date:   Tue, 25 Aug 2020 09:55:17 +0530
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     Greg KH <greg@kroah.com>
Cc:     stable@vger.kernel.org, Viresh Kumar <vireshk@kernel.org>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Rajendra Nayak <rnayak@codeaurora.org>,
        Sajida Bhanu <sbhanu@codeaurora.org>,
        Sibi Sankar <sibis@codeaurora.org>,
        Matthias Kaehlcke <mka@chromium.org>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - stable v5.4 and v5.7] opp: Enable resources again if
 they were disabled earlier
Message-ID: <20200825042517.gui4kovio4xcu2w5@vireshk-i7>
References: <31f315cf2b0c4afd60b07b7121058dcaa6e4afa1.1598260882.git.viresh.kumar@linaro.org>
 <20200824161049.GE435319@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200824161049.GE435319@kroah.com>
User-Agent: NeoMutt/20180716-391-311a52
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24-08-20, 18:10, Greg KH wrote:
> On Mon, Aug 24, 2020 at 02:52:23PM +0530, Viresh Kumar wrote:
> > From: Rajendra Nayak <rnayak@codeaurora.org>
> > 
> > commit a4501bac0e553bed117b7e1b166d49731caf7260 upstream.
> > 
> > dev_pm_opp_set_rate() can now be called with freq = 0 in order
> > to either drop performance or bandwidth votes or to disable
> > regulators on platforms which support them.
> > 
> > In such cases, a subsequent call to dev_pm_opp_set_rate() with
> > the same frequency ends up returning early because 'old_freq == freq'
> > 
> > Instead make it fall through and put back the dropped performance
> > and bandwidth votes and/or enable back the regulators.
> > 
> > Cc: v5.3+ <stable@vger.kernel.org> # v5.3+
> > Fixes: cd7ea582866f ("opp: Make dev_pm_opp_set_rate() handle freq = 0 to drop performance votes")
> > Reported-by: Sajida Bhanu <sbhanu@codeaurora.org>
> > Reviewed-by: Sibi Sankar <sibis@codeaurora.org>
> > Reported-by: Matthias Kaehlcke <mka@chromium.org>
> > Tested-by: Matthias Kaehlcke <mka@chromium.org>
> > Reviewed-by: Stephen Boyd <sboyd@kernel.org>
> > Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> > [ Viresh: Don't skip clk_set_rate() and massaged changelog ]
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > [ Viresh: Updated the patch to apply to v5.4 ]
> > Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> > ---
> >  drivers/opp/core.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> This too is already in the 5.7 and 5.4 queues, why add it again?

Same here, your bot reported that patch failed to apply for 5.4 and 5.7, again
rightly so as I was required to modify the patch a little bit and so I have
added another signed-off and details.

-- 
viresh
