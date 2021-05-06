Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADA3375892
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 18:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235881AbhEFQlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 12:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235295AbhEFQlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 12:41:12 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DD4C061761;
        Thu,  6 May 2021 09:40:13 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 10so5686819pfl.1;
        Thu, 06 May 2021 09:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xXizdXUAjSz2jlshC5sOnX3iWhZuSTNGCElXukfmD5M=;
        b=cR1tnwk3T/Wvlf5i9dst9jZsGLRtAexfDn11Uag1slcnP4yE6mHoDHZBR7IwSlcU0Q
         6L2LTwSOtFe8robwxXO+Rm/EOV5d00Jo+lsHdOv5UvPYsCicJIjSSTMaG0bvzx6rKAGW
         Div/waoPb4F9hvalAUjlf6OAOanR/o1ROOP3J5aJ6ENyc5aXoPxtdlgcMPQsptVOxRxm
         YLRtc6+aqtjUHf4X8rPjeCN0gOBcbde4/iZsmg+6l/ezwPCnA52ns1Amk8EYbbe6QN+m
         jctKrRRcsB8XnqJcLZoQ6QNbVYLk1pDMV05XF2P/x85vwu/cRJkKaEtzUmtzfBZsxNcE
         oeaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xXizdXUAjSz2jlshC5sOnX3iWhZuSTNGCElXukfmD5M=;
        b=uduPj7unvm7AwXn7hS6LBdgvJqVio6cj2E85vrgwitf5hfjD+lScr28rp13tIoZYyb
         aKdIl/YLZtR1zaXYa/xfqO0wUgBZFgWcUWOokfzFhS1iHcZG0hK2tHVp4fLMbt6Vl6jO
         otcDqHFKmbGBCAyZgIdBWJQLbrGDVDw9iCOMVsOxKlczNSMklydoNe0pSSkO2x5/kXNZ
         JLnaku9JiHCGsbmeyd/NFVsU7398wj4I1jAU6+YDrTltdKR0U7BemEtYxUq+qgxzLbH+
         O2vOuhtamLgi0rJj3MiCCrzi1QMFXJsad1jSe5BHTOrmx67L+7zxVd8LfL++3l0D2azB
         88RA==
X-Gm-Message-State: AOAM532zOn/9OG3rTDzyCUuM2u8eR9vbXH1sbF01hm5ynulMQnU160Gl
        mTuHld5srj12gC1/cCv7U7ti3j8jea8=
X-Google-Smtp-Source: ABdhPJwkAm4sp2Mpia1QZcz8GR74jexVpEP3bV089siY28rgybUrpG3UPDNl5YQIkKDLtXCXh+TwtA==
X-Received: by 2002:a63:4c0e:: with SMTP id z14mr5198740pga.30.1620319213313;
        Thu, 06 May 2021 09:40:13 -0700 (PDT)
Received: from atulu-nitro ([122.178.201.168])
        by smtp.gmail.com with ESMTPSA id lx15sm9867586pjb.56.2021.05.06.09.40.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 09:40:12 -0700 (PDT)
Date:   Thu, 6 May 2021 22:10:08 +0530
From:   Atul Gopinathan <atulgopinathan@gmail.com>
To:     Peter Rosin <peda@axentia.se>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH 27/69] cdrom: gdrom: deallocate struct gdrom_unit fields
 in remove_gdrom
Message-ID: <20210506164008.GA6283@atulu-nitro>
References: <20210503115736.2104747-1-gregkh@linuxfoundation.org>
 <20210503115736.2104747-28-gregkh@linuxfoundation.org>
 <223d5bda-bf02-a4a8-ab1d-de25e32b8d47@axentia.se>
 <YJPDzqAAnP0jDRDF@kroah.com>
 <dd716d04-b9fa-986a-50dd-5c385ea745b2@axentia.se>
 <20210506143208.GA7971@atulu-nitro>
 <1912bddd-0788-5586-1cb0-0400630c32f8@axentia.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1912bddd-0788-5586-1cb0-0400630c32f8@axentia.se>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 06, 2021 at 05:43:14PM +0200, Peter Rosin wrote:
> Hi!
> 
> On 2021-05-06 16:32, Atul Gopinathan wrote:
> > 
> > Apart from this, I don't see gdrom_get_last_session() being called
> > anywhere. But I could be missing something obvious too. 
> > 
> > If you don't mind, could you point out where gd.toc is being used in
> > probe_gdrom() before it is kzalloc-ed in the same function.
> 
> You are very probably correct in your analysis, and I can't find it in me
> to spend the time to dig any further.
> 
> I simply thought it bad enough to hand off a pointer to a function that
> uses a stale pointer to some other driver. I never dug into that other
> module like you did. Relying on that other piece of code to not use the
> function that was just handed to it is way too subtle (for me at least).
> When you "register" with something else, you should be ready to get the
> calls.
> 
> This is true especially in the context of what we are fixing up here;
> broken shit related to people that are fond of weaknesses later to be
> activated by other innocuous commits.

Ah, I see, that makes sense. I just wanted to confirm if I was getting
things right. Thanks for clarifying!

Regards,
Atul
