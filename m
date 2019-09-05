Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43634AAC7A
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 21:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728534AbfIETxN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 15:53:13 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42197 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfIETxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 15:53:13 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so7521497iod.9;
        Thu, 05 Sep 2019 12:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=gG9KTAfYKzS7FOWEmgdcmC13OEeU2qK9XGG/GnKeVVA=;
        b=fIho/fn0zvgExeCQjHj5HHH/iPRP6Kw7SNaiJKN8JNhP2+RqpFTHGyISd+H8d86xPN
         n17KZrmmSA280m99UMUt3uLb7FXAmaIKGE6Zd/9jNdioqTaB1DmwbEMoE/HjJl8ScfKp
         zhV6Hy4PLsPxG7r0PV6iStQ2+UXRVc0ImZbLo6nU0tyQEaMQTG1hvSj1q8VSr/3tRHOP
         OOd+HRNTBVnZxBw4X8rSVNeH1oHhYrwlU6gLrr8crv1xBRtfF6ei5+DUsZj/ZJOkRjEd
         890gTpahv1Y2+K324/86qNuK4jTmu04qD/9o2AFdgxDcIn+d89JUsWPHxWY5a8/VuEU5
         8geQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=gG9KTAfYKzS7FOWEmgdcmC13OEeU2qK9XGG/GnKeVVA=;
        b=Y9qrD4kbctSEHrDcAlvyVnzQlJp60R7G8vyViE6UE8N06te/eodsNEKAQ8WidEsYVk
         m9Px5Wz9gQxsWnvxanY73Y2ARDhwSwlQGgrdV6mL7r6HAw+IA/JLrAHx0DnCl9S04fck
         wsxqVoM18Yis4jo9y+gUHCQUetPPbPTQJSt5py5hxGIrOqs//XIwp9URdARc2B3GNW1h
         T6r5x42I6LAM9RZkyoZGrcS40w695louRrgAwaQVb2qRoObuGD6MULv8eGkXHlIRTPOP
         nwSPMYjSjIAcX8x3v4WARhcKCxkqGdHd1arUGiANqP6Fd0jDGEZWyA3fWwZZG6WEN+r4
         d8gQ==
X-Gm-Message-State: APjAAAUuvP4sfISO95rPRrvCYxSq3woPO9McU+vWkauXgs9R0X6J10BL
        l8C9rCWUGTBVONwZ4Z/tXM8=
X-Google-Smtp-Source: APXvYqyT6acH01dQQdfxN3ejBgrevYziuJVmgn4FLVGJCEmSW2FHTW03ETVm+jzt0uCRrq1aM5L6Og==
X-Received: by 2002:a5d:91ce:: with SMTP id k14mr5856951ior.95.1567713192152;
        Thu, 05 Sep 2019 12:53:12 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id b7sm2577426iod.78.2019.09.05.12.53.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Sep 2019 12:53:11 -0700 (PDT)
Date:   Thu, 5 Sep 2019 13:53:09 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/83] 4.9.191-stable review
Message-ID: <20190905195309.GE3397@JATN>
References: <20190904175303.488266791@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190904175303.488266791@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 04, 2019 at 07:52:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.191 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 06 Sep 2019 05:50:23 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled, booted, and no regressions on my system.

-Kelsey

