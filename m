Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E10364D51D7
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 20:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240901AbiCJTGC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 14:06:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239330AbiCJTGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 14:06:01 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7278141E3E;
        Thu, 10 Mar 2022 11:05:00 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id k25so7549725iok.8;
        Thu, 10 Mar 2022 11:05:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OKFP8TqzjD87nVnA5QCfg2pISdNFfHhzbTP/7HGxIhA=;
        b=ANDDgCAiRgwX5/BicfRIRlq1ry9MZ/5pAG3MF9mbAjKeMSPcOPWeYGRSFQ1V3IpEN7
         rphSEN+eLQbzNrZCae8zaz/Z1SEJBAC3LpfWkmlNICmsftdOvape8SvUqhhIWM7ykXti
         JPzaOIpsJvtAbVnm6K5SlkprSLw9uiNYWwp2PIDnVMmhJO5Q7uD7ww08dxkHCNagVXia
         G8eJHqmmA9J3/mYnYI02JLBK/aPn3+AVzCcN49mIbuObm7xl9Fb+Ve2Mo1YQI4oWqS1M
         zRGm9sr3VAa76oYzUVD8xBvdvxwehgdozkQvlc6ddqkBlRf3o5iDKhb9dEmq/BTapUh0
         SIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=OKFP8TqzjD87nVnA5QCfg2pISdNFfHhzbTP/7HGxIhA=;
        b=2Ixy3GwUnsF2DbcqV4S12iGTee8JgcbNdWcUc6lBVRpsuhP0ckZDBiKkYAO4ADCwz/
         TgsGwdjIx15N1z+z2ZBl7EvePKhOh/n5nYtFiQIINBnL6BcEm3XRgH870I6n/YFcESzH
         PJmNVSSlpzxdd1bWSr6Gc2rdqnEWS6QUq7rxH63BSYAEUEKis7yqrjvjy+XtIdmP2qba
         InHHDTrzZfYZlHoCsFoK8BSXfoPP+enJvdj9Vwt1PK0bwCTUNfP03/OMFDt8jefsticb
         IjlltwNIyYGHe0F+OxX4QHT6pZvf9glSnAz6qi9uvm+n1NAA46CpgJx1XgwJrghKqHRF
         NDdw==
X-Gm-Message-State: AOAM530xQmkNaOz0LxzXo8ceXddVoKkcNub/47nIPOL2NTxbXvXNwdqR
        9YBu9GNwF/zNJX+/1uwV7Mi849bDCop5Z0f8jkz1Ug==
X-Google-Smtp-Source: ABdhPJyZwwfpJg61uLGZ3a3+jR2rZ+jGBrNph/zEz+UzcqwWWS2mSomRDgTHrNaiFsDkpmcIkk5fZQ==
X-Received: by 2002:a5d:9d91:0:b0:645:bc14:47bd with SMTP id ay17-20020a5d9d91000000b00645bc1447bdmr4807359iob.133.1646939099548;
        Thu, 10 Mar 2022 11:04:59 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id y6-20020a056e02178600b002c613ccce6csm3422334ilu.48.2022.03.10.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Mar 2022 11:04:59 -0800 (PST)
Message-ID: <622a4bdb.1c69fb81.27616.e9c3@mx.google.com>
Date:   Thu, 10 Mar 2022 11:04:59 -0800 (PST)
X-Google-Original-Date: Thu, 10 Mar 2022 19:04:57 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220310140812.983088611@linuxfoundation.org>
Subject: RE: [PATCH 5.15 00/58] 5.15.28-rc2 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Mar 2022 15:18:49 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.28 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.28-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.28-rc2 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

