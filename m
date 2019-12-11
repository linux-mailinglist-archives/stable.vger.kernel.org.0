Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1C3F11BF11
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 22:23:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726368AbfLKVXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 16:23:15 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34862 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfLKVXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 16:23:15 -0500
Received: by mail-pg1-f195.google.com with SMTP id l24so11360995pgk.2
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 13:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PiR4x9CoXnfWfCbQNTlgRP9ROMJUyaR0E0re5tOFBZ8=;
        b=ic5e0TCqEoJNzj9fGsZQ5N9SAW1l1zgvcZjd56LeFf5mo1wulGCYmSTCjH4ILs0YEe
         l0mfUZXXjf3ooPnzRT1O5RQkCzKRkw3aqkN6c2aPB9HdsQAWkzDvP0cx/iGQbWP2t3pu
         OlFJpnzJ8dCIZifbJ784hdGKIMOGG7yVROYcG8TJl58+nHOnsMoJJT25BopTVvv3IMg0
         S30euSGIGuRb5eKE8njTHIQT51IW4VwwnkkUIrzA4M5bZFNYAkPcWIKJKhk5HR8BLGEx
         OdYbcmbLDNTSUSpgsSTjJLijaP52w2E5/t0+bLYB1g51M7v/881bd8pQZo7cFN8SWmSx
         F1cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PiR4x9CoXnfWfCbQNTlgRP9ROMJUyaR0E0re5tOFBZ8=;
        b=ECRUrlWU23PgkV3+SwYhtGHdVyoKepMeD4Z8wGFcJDk2qezP5KppW74mcO/CFs0f4D
         KnYy11sbdW1zqodXY8Q1+XIjJ6gLxWrpUwcB0Q81CE4vwNaOgWx58RezdRvJC1eG0/r1
         Onebnpw3ZON0syiCkHIYyphs8piyW5f21cVU6UzXX0CPH7Wzb5lw2hPueFJg8PKuLeyg
         BuK5CHMmLjuIq2bMd34oAkYpCpr8Bzo/c8i700hziTMayJYBoztVSLJ/daEHrMNlXIB/
         7vbFb6vMIRdPaS8E8xujtYDDcK5ppFeeRB6/qHHK3e2TQXNWb1d43T8aJOx6S28orkUs
         +Nfw==
X-Gm-Message-State: APjAAAX8UQVCu51D8FjceGS02YSDQr/5gNfGqIvVedIVhtUsmyn4xFvE
        cmhb/+SKN0uerBctU1CoA9eHLQ==
X-Google-Smtp-Source: APXvYqwrFaHj1syZQej9q7UGHjSQjK/MJs091CunWjBi0pCJ3ZbBj0eGGn30dTwTAbwGEIu9ylCCTQ==
X-Received: by 2002:a65:5cc2:: with SMTP id b2mr6457132pgt.171.1576099394769;
        Wed, 11 Dec 2019 13:23:14 -0800 (PST)
Received: from debian ([122.164.82.31])
        by smtp.gmail.com with ESMTPSA id i3sm4270815pfg.94.2019.12.11.13.23.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 13:23:13 -0800 (PST)
Date:   Thu, 12 Dec 2019 02:53:05 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191211212305.GA2676@debian>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191211161605.GA4849@debian>
 <20191211182852.GA715826@kroah.com>
 <20191211192232.GA14178@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211192232.GA14178@debian>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 12, 2019 at 12:52:32AM +0530, Jeffrin Jose wrote:
> On Wed, Dec 11, 2019 at 07:28:52PM +0100, Greg Kroah-Hartman wrote:
> > that's really odd.  How are you building this, from the git tree, or the
> > tarball generated?
> git tree
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> 
> 
> > And I still see that file in the 5.3 tree, what do you mean it was
> > deleted?
> 
> may be during "git checkout linux-5.3.y" or may be i did "git pull" inside that branch
> 
> that was a git status which showed "D" at the start of a few lines
> and one of that lines showed that file.
> i also checked that path locally and found it was not there
>

i downloaded the tree to another directory.
i compiled the kernel and it was a success

--
soffware engineer
rajagiri school of engineering and technology

