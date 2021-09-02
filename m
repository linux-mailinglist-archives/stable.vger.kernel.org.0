Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07163FF198
	for <lists+stable@lfdr.de>; Thu,  2 Sep 2021 18:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346407AbhIBQi7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Sep 2021 12:38:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346347AbhIBQi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Sep 2021 12:38:57 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FDE3C061575
        for <stable@vger.kernel.org>; Thu,  2 Sep 2021 09:37:59 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id y17so2071310pfl.13
        for <stable@vger.kernel.org>; Thu, 02 Sep 2021 09:37:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+4Orx9zvUd5x4aUKtZah39XgU+JJpqGPZyNTne9OEDU=;
        b=OhE2eEmltZEIwJDWD36yGRLAXPRqaJ0zu9jLEWlfS5B/kZo8cJiYeFwICWcb8VgELO
         YB7gi0hXiSZMduH1u1B0fOh2Oz3rHYu7QEWd9bhihl4GhEqXLx3yLxn2B7yeGIXac69d
         C1KlFjOVsmlxykG49N85WEltnOVeiy9A9m2VsMOdeaHBY1OzCd/Otn9xkj57sus4B4MW
         9fhCBeTL84jpvAoUpvjF5h2LWCVLw6lpvytXpZNOvD6ICeoQOZfox8XEK+YmLtbC5Ort
         BeqqNTNTdUWeNaE2FURKq8t05a3gDCL9F9hUCLLG8jLN6CehkoTpdz2IWKgrN6+O5dRY
         j02g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+4Orx9zvUd5x4aUKtZah39XgU+JJpqGPZyNTne9OEDU=;
        b=CBjUhOaLY8KBjE/5Goe6LHIDHMN0I8Oh/7A9iFGnIal2OnshZdLQDdbf7c5Jn2nSgZ
         2SGlTNrXqP4nETphoT4qmAoEXU98P0oR9nZxkj57A2LzXDZ3o4lXnG9kjNw+WF7Ax/2O
         GpUuL5dxTRsiW8rUTW9xm1QgqfiOvs1mHrKfGfWeFzMKTaXRT3Yp70dloB1f+Zj7dykO
         bd3zc898HQWclCTmWk6URmVt+XlesO2SsmRV6FPTYxepAJQCexfPA+vxFYBIvNPEqY1z
         eTmRy6BuFTHSdl7FKEUto8hwwxtL2/DZ1V6yr5TbsHbAEC1zFNaeqHqgVv/OLEXQ9iDt
         zPeg==
X-Gm-Message-State: AOAM531nqwwlRfn5m0Vt2dsjne8dak2AT3BY4uGPBd8DLy9XGnLSElYJ
        3YIiDPXZt1Cw/mTmTxKivceh/HlBHOK6zA==
X-Google-Smtp-Source: ABdhPJz/HqZ1sJxvDuJCTcIwrdFzBXUpv+ozByYXRapcHopCTpg4tNsK9l7W3IEs6UEFX6GhWv8KeQ==
X-Received: by 2002:a63:ec45:: with SMTP id r5mr4086586pgj.440.1630600678603;
        Thu, 02 Sep 2021 09:37:58 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:400::5:a2b2])
        by smtp.gmail.com with ESMTPSA id j6sm2775809pfi.220.2021.09.02.09.37.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Sep 2021 09:37:58 -0700 (PDT)
Date:   Thu, 2 Sep 2021 09:37:56 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: Linux stable GitHub mirror stale
Message-ID: <YTD95AbxXRlgVaPr@relinquished.localdomain>
References: <YTAL8S9qxfhsO/iG@relinquished.localdomain>
 <YTBihMQq7H9vWazh@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YTBihMQq7H9vWazh@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 02, 2021 at 07:35:00AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Sep 01, 2021 at 04:25:37PM -0700, Omar Sandoval wrote:
> > Hi, Greg,
> > 
> > https://github.com/gregkh/linux seems to have gone stale. The last
> > update was about 24 days ago. Do you know what might have happened
> > there?
> 
> Yeah, my script acted up if one of the "mirrors" started failing, then
> the remaining ones would stop being updated as well.  Should now be
> fixed, thanks for letting me know.

Yup, looks good now, thanks for the quick fix!
