Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D0F273F18
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 12:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbgIVKAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 06:00:54 -0400
Received: from mo-csw-fb1115.securemx.jp ([210.130.202.174]:42038 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgIVKAy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 06:00:54 -0400
X-Greylist: delayed 305 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 06:00:53 EDT
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1115) id 08M9tn9i026166; Tue, 22 Sep 2020 18:55:49 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1115) id 08M9svQE031350; Tue, 22 Sep 2020 18:54:57 +0900
X-Iguazu-Qid: 2wHHurbveqwmE2EIBU
X-Iguazu-QSIG: v=2; s=0; t=1600768496; q=2wHHurbveqwmE2EIBU; m=FoGx0ZoyjsZMhHBSRlztv9GUUBIx3nmzpHB7u+TbUW0=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1112) id 08M9srmo031408;
        Tue, 22 Sep 2020 18:54:54 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 08M9srRQ010591;
        Tue, 22 Sep 2020 18:54:53 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 08M9sqQU012389;
        Tue, 22 Sep 2020 18:54:53 +0900
Date:   Tue, 22 Sep 2020 18:54:51 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/46] 4.4.237-rc1 review
X-TSB-HOP: ON
Message-ID: <20200922095451.ryfke743wp6jajs6@toshiba.co.jp>
References: <20200921162033.346434578@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162033.346434578@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 21, 2020 at 06:27:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.237 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.237-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
>

There were no issues with CIP's kernel builds and tests[0].

Best regards,
  Nobuhiro

[0]: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/192607192
