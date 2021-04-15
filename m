Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5002E361168
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233052AbhDORuR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 13:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233687AbhDORuR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Apr 2021 13:50:17 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FFD1C061574
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:49:52 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id o13-20020a9d404d0000b029028e0a0ae6b4so4291833oti.10
        for <stable@vger.kernel.org>; Thu, 15 Apr 2021 10:49:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FoH9tCIame1GtbuegY70irnEU7UYGnRC7FuBQwQzDQk=;
        b=ThRtefc7eQ8A+gkrzAIe/H6u+h5WH3epY9gyqdxcaE4O1FMEoAUKujZrh2dBqSueJE
         l1fTmXstreF7RvJdFNNy379KtQvI7GouP+Ws+0Y2+ZihpbXWFy0K+Pk/eGjXeqE72PCk
         iPdVroFBmfyCGSZnz2AddRbXxFu5qwMzasy+DPc9xpPh9tcZjOeQV7fLKuM3VWedBOtT
         J8ZcfP1mQ+pqN3FNIM2td/syUHEmNPSdyNTUeaBIOILj9Oodfxz1gXkEPEcxKyfCJRqw
         dSGB5gWQvjxqEpJK0B72P1/4oOIZK7MFyLTQ7jUj3kqjwqUTSs/jm61+atLBQg+xBE9i
         LcbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=FoH9tCIame1GtbuegY70irnEU7UYGnRC7FuBQwQzDQk=;
        b=mJdx6h982qqf1pw/VeuovyjTy5IXT7dqDWZ/6z7v/NyC2aNjv2JBBvEXOU00jEakPH
         rT4xNqfT26FcJ7+eNGV2+sZddv7eliOKAFaX9iv+z09kaB/jXtC56i40oqFfLvUWKAes
         YZmPvg3vrB29YTtydJlDgL/nKuId1e8ziq6SeWYWQynQvND79bpjrWKjVdPlLR3LEbTt
         BU3MasHIcToM9LIo+oJ2W6pxngXfWLiQcU9whLjy9NFOItppbttQKduWd39sqyURFW01
         JeiW193aO0mOozOSvT2TggB2zR9UVhoTlj9psumv2Da792ncWRukoImqAMR7qEsOFsVt
         HPhQ==
X-Gm-Message-State: AOAM531JrSVySIcESPXATt9pkTm/vhTubzXaxb4NfGo5Vpdx7eeZHPYg
        gvXq8eUZAGtBHZXjwPf2U9U=
X-Google-Smtp-Source: ABdhPJwBvnUpHZ9NBJZGVYN68V+qM4aPo1pLUBwM4OXAV0OG/P98XSkgrL4U2F+2MI63t1Iaij/qHw==
X-Received: by 2002:a9d:206:: with SMTP id 6mr340719otb.309.1618508992008;
        Thu, 15 Apr 2021 10:49:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h25sm670178oou.44.2021.04.15.10.49.50
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Apr 2021 10:49:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 15 Apr 2021 10:49:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: netfilter/x_tables patches for v4.4.y..v4.14.y
Message-ID: <20210415174950.GB30478@roeck-us.net>
References: <1780f159-140b-231f-8af5-ccec049dc8b0@roeck-us.net>
 <YHhr1WuX4/0l+9lP@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHhr1WuX4/0l+9lP@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 06:37:41PM +0200, Greg Kroah-Hartman wrote:
> On Thu, Apr 15, 2021 at 09:28:15AM -0700, Guenter Roeck wrote:
> > Hi Greg,
> > 
> > please consider applying the following two patches to v4.4.y, v4.9.y, and v4.14.y
> > 
> > 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used anymore")
> > 175e476b8cdf ("netfilter: x_tables: Use correct memory barriers.")
> 
> The second patch here says that it's only needed to go back until:
> 	    Fixes: 7f5c6d4f665b ("netfilter: get rid of atomic ops in fast path")
> 
> Which is only backported to 4.19.  So why do older kernels need that, is
> the fixes tag wrong?
> 

Outch, it looks like 80055dab5de0 was fixed later with cc00bcaa5899, which in
turn was fixed with 443d6e86f821. Ok, back to the drawing board, but it may
just be easier to forget about this. I'll let you know.

Thanks,
Guenter
