Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB1B8FB2C
	for <lists+stable@lfdr.de>; Fri, 16 Aug 2019 08:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfHPGij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Aug 2019 02:38:39 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:46740 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbfHPGij (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Aug 2019 02:38:39 -0400
Received: by mail-io1-f66.google.com with SMTP id x4so4177524iog.13;
        Thu, 15 Aug 2019 23:38:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=t8+aRfpHFKZoqqgIR6qH7+QBwdZXqxMwXd9QBUEx0dw=;
        b=Waeog4Caec2pxH2qlmLYguXz87TIkpm8iKDcIMycfnfcqmhOQtwrULlf2m+GAJN7fT
         XgIhuCa+rdgyK3Vn2ZyJQ1+BioH1PF1wtdU2CJgGsjLYVXsNE1p+fKCeIyXE1t9EZX6j
         x+9BW8XevsM/xV+tWnu1I5WUFz3GvVgKifQeu+kr26HN2bSfRSyvE6sb9MBBlr0wpkos
         RNym8Hw616y+/p2b9W7PP8SutnkZnyc2AXQDN6wgJc5ZHQ3DAOK/YgiKKoZI61/QO0hT
         lX3+2imyu7JNV6HpSTyFp2T6CfP1YPN0U6zUUJMkLpl7LczM54Tft/sKS2xaB9oCHGUH
         2f8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=t8+aRfpHFKZoqqgIR6qH7+QBwdZXqxMwXd9QBUEx0dw=;
        b=XzVXKT0KXkjkXucVn67slLgkhhYjSAhDA8RC1A21TOGkNPao0VsDUAWoqPvLa0KJ/0
         y/0gnWuymh7DK0euP8Ppkq9WTyfL7KR18HIerNbcATqgISEuiXciV8cjY389ZjChprE1
         zrSJp8lZOpIt42ZINI7eMiRy/yJJlOdRoBgrH24jzg+R3bXv6/wgw3hCIX0D67eoOAFt
         nM3hKe8hGnChVWNndCQr8MnBmSm8/6IbcbjL3PpLDtC7DyDXMvf30J1lmUq/WS67N1gf
         YOi0SXbm5WUf3ZOtm77NIXuH3os5dEV8MbsducfciR6Cn67SUIvrGG7V3DYbW1nSMbj3
         0lhQ==
X-Gm-Message-State: APjAAAUCt3MeewzwaeuO/SIsnMmyCq+fS1x4GT/ppNVc114wA4BfZShY
        nSQ767vX6SuT9O8ZOPMm5dM=
X-Google-Smtp-Source: APXvYqwZEghYw3vym/QHGnEyeR5zmvBkxOIg4jvilHMIWzLAAvhESDVPkeWvAaGO4ZpEc6y0zrATig==
X-Received: by 2002:a02:487:: with SMTP id 129mr9014596jab.113.1565937518834;
        Thu, 15 Aug 2019 23:38:38 -0700 (PDT)
Received: from JATN (c-73-243-191-173.hsd1.co.comcast.net. [73.243.191.173])
        by smtp.gmail.com with ESMTPSA id o6sm3263458ioh.22.2019.08.15.23.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Aug 2019 23:38:38 -0700 (PDT)
Date:   Fri, 16 Aug 2019 00:38:36 -0600
From:   Kelsey Skunberg <skunberg.kelsey@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/91] 4.19.67-stable review
Message-ID: <20190816063836.GB3058@JATN>
References: <20190814165748.991235624@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 14, 2019 at 07:00:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.67 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 16 Aug 2019 04:55:34 PM UTC.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Compiled and booted with no dmesg regressions on my system.

Cheers,
Kelsey 
 
