Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6412D3A087
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbfFHPtb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 11:49:31 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:54296 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727035AbfFHPtb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 11:49:31 -0400
Received: by mail-wm1-f68.google.com with SMTP id g135so4755944wme.4
        for <stable@vger.kernel.org>; Sat, 08 Jun 2019 08:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=pHGpvWmmPQbNLDzox15I+1ID77/pKQSuG/kdotxbyDU=;
        b=WASMWQOV449j6tB3p0A0/w6doEQNsdmkTUh2Em/dCmvDZGH+AFjH/0xfLUnOy4vnOJ
         +NxHs2xkACypdPpWxlpNh5CdqlxgpD0+kxTeIfnAHToKGvG4vNK5jcPPBz/84/0R5EpN
         a8eBOsN74Ewx24z6rPfLyccmm70d5HMKeq/8FlN5DleNTHLtk8eS28ZwmBlze7Dy3aLC
         882HzvMH2uxtDc5o3wqOfTCuyzvHf8t6ABjUA+coKI43dxf7cjh/9T1BOS0uhmtjqnMs
         3dGbVibYg8MbZ1KbjdS0bJIw2x9XR5UEExcDmObcah1GE0V0CK7LIOhvLdYM0LTVQ3jE
         wzIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=pHGpvWmmPQbNLDzox15I+1ID77/pKQSuG/kdotxbyDU=;
        b=TfGgn9gznW81fVSg/klbgCysMPppzK0meKosH1ddx/NoM8hT3zNbVxVP982RgxqXXq
         LkudG9trwIdVoa7SV+XllMLGO41Pxl3TAsQjvYcK2K+ZLE0iQnPc0PnEeXaVJHv9sMUT
         OFAprJ8FUGyWmoP2wN6ZdwQk9Ejgpu/WqCTVspKu8w/V9rjgl69nheod7vHVULORYPf8
         PmgZDU421zjqw3/fXlOUyRvHUHbFvwiFS/QVyFD2iBbjL1TXSUoqf/4DaiNCgLI/xo+D
         PuhAHAWDN/1dhDV189RYPTmcsI012BOe1zywpAFZeZe1nCMQvusLj+UiZUhq5lcdr8uh
         dEXA==
X-Gm-Message-State: APjAAAUYdbQ7UIdLE+tCubyVfCiWjtS8mi5YQaR5WJ0TidGjk88pEwaV
        M+Ioa1W5Z2UCs2vupT/5ti0=
X-Google-Smtp-Source: APXvYqycBoqoeEyOepgzUUEhO7PeTzhQAiQxVYa7XDbaHP/LpMntISaLNlf5G7tefxqocz0Y/LxHsA==
X-Received: by 2002:a1c:a6d3:: with SMTP id p202mr7872682wme.26.1560008969746;
        Sat, 08 Jun 2019 08:49:29 -0700 (PDT)
Received: from zhanggen-UX430UQ ([108.61.173.19])
        by smtp.gmail.com with ESMTPSA id z6sm6556673wrw.2.2019.06.08.08.49.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 08 Jun 2019 08:49:29 -0700 (PDT)
Date:   Sat, 8 Jun 2019 23:49:14 +0800
From:   Gen Zhang <blackgod016574@gmail.com>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     Zubin Mithra <zsm@chromium.org>, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, groeck@chromium.org,
        davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net
Subject: Re: 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in
 ip_ra_control()")
Message-ID: <20190608154914.GA3449@zhanggen-UX430UQ>
References: <20190603230239.GA168284@google.com>
 <69e47f52ec342b6c70c1cae6cd0140a51a713752.camel@decadent.org.uk>
 <20190607024115.GA4196@zhanggen-UX430UQ>
 <b1c9339054e583569888243331c0c7dd28591410.camel@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1c9339054e583569888243331c0c7dd28591410.camel@decadent.org.uk>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 07, 2019 at 02:02:09PM +0100, Ben Hutchings wrote:
> On Fri, 2019-06-07 at 10:41 +0800, Gen Zhang wrote:
> > On Thu, Jun 06, 2019 at 07:58:35PM +0100, Ben Hutchings wrote:
> > > On Mon, 2019-06-03 at 16:02 -0700, Zubin Mithra wrote:
> > > > Hello,
> > > > 
> > > > CVE-2019-12381 was fixed in the upstream linux kernel with the commit :-
> > > > * 425aa0e1d015 ("ip_sockglue: Fix missing-check bug in ip_ra_control()")
> > > > 
> > > > Could the patch be applied in order to v4.19.y, v4.14.y, v4.9.y and v4.4.y ?
> > > > 
> > > > Tests run:
> > > > * Chrome OS tryjobs
> > > 
> > > This doesn't fix a security vulnerability.  There already was a check
> > > for allocation failure before dereferencing the returned pointer; it
> > > just wasn't in the most obvious place.
> > > 
> > > I've requested rejection of this CVE, and several other invalid reports
> > > from the same person.
> > And where did this 'invalid' come from? Did any maintainers claimed the 
> > patch 'invalid' or something? I am confused...
> 
> I'm not saying the patch is invalid.  It makes the code clearer and
> seems to result in returning a more appropriate error code.  So I don't
> disagree with the patch, only the claim that it's fixing a security
> issue.
> 
> My requests to reject the CVE assignments were made using MITRE's web
> form.
Well, I see. Thanks for your comments.

Thanks
Gen
> 
> Ben.
> 
> -- 
> Ben Hutchings
> Life would be so much easier if we could look at the source code.
> 
> 


