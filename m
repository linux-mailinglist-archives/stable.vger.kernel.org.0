Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B91273F26
	for <lists+stable@lfdr.de>; Tue, 22 Sep 2020 12:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgIVKCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Sep 2020 06:02:41 -0400
Received: from mo-csw-fb1514.securemx.jp ([210.130.202.170]:33292 "EHLO
        mo-csw-fb.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726506AbgIVKCk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Sep 2020 06:02:40 -0400
Received: by mo-csw-fb.securemx.jp (mx-mo-csw-fb1514) id 08M9vNb9031153; Tue, 22 Sep 2020 18:57:24 +0900
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 08M9ugd3031126; Tue, 22 Sep 2020 18:56:43 +0900
X-Iguazu-Qid: 34trqPsSB8APpTFo8I
X-Iguazu-QSIG: v=2; s=0; t=1600768602; q=34trqPsSB8APpTFo8I; m=UCU3inFh6jWp65TCo9cKydG++C3roBjZpDdDTkijYEo=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1510) id 08M9ueoX016443;
        Tue, 22 Sep 2020 18:56:41 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 08M9ue4a016845;
        Tue, 22 Sep 2020 18:56:40 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 08M9udac009015;
        Tue, 22 Sep 2020 18:56:39 +0900
Date:   Tue, 22 Sep 2020 18:56:39 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/49] 4.19.147-rc1 review
X-TSB-HOP: ON
Message-ID: <20200922095639.uagetymo3inf6zr5@toshiba.co.jp>
References: <20200921162034.660953761@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Sep 21, 2020 at 06:27:44PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.147 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.147-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

There were no issues with CIP's kernel builds and tests[0].

Best regards,
  Nobuhiro

[0]: https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/192607280

