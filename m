Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC7935AF64E
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 22:47:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229804AbiIFUrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 16:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229693AbiIFUrO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 16:47:14 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECAD915C0;
        Tue,  6 Sep 2022 13:47:13 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id 130so13038738ybz.9;
        Tue, 06 Sep 2022 13:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+WURMAVRZWoeEl3WfS2Wri6rYAcNRWeV/u+drCF3J74=;
        b=Ety/usxvSDrpSlVHwhRJBA2Gy9vFEi2BJhkDv8zvEipJZz4J8fsc0PEt5E3GeUGjCs
         rY/tNzWizv4kDArNaeIcPdoCaFqQyk1+FbzP2ZfKdqach02cd/MwU+7NbuO7ncv3tPRw
         C+D28ruAzEfInAgr/0j2mVlP14uRWbtY+uXLRPRERQaqMOv6V8T6Mr6bQjOijtDk9hCQ
         M8wgWl06tFlkpZJkAAqd+9yiyX0keQgduCvkLcob2Ssmir3Wb1BXhEQgkIxu8l+thW1p
         eAKLlzzw2k3QxgV+k2zsx5QxysjSLUNtI7fL47Gg4vkvaGOs0vuXx1HQ32m7gotFejiI
         eu/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+WURMAVRZWoeEl3WfS2Wri6rYAcNRWeV/u+drCF3J74=;
        b=wCNSsujl3fyDWhSKRiAVMkwffYkvpTjNJJUx47tI/Tif8AAPG0y9N8ICKkW1BPkRU2
         5R4V0bTLzn9ygt7nzCJxfnBnEtvoxRYsPMcwITdackApfzvdyhmxplYxuGyXLZBGX8W8
         1KrnmrXgfaJ9y99OtcPmVm7q4+1+gOg+kqtAywSu50SPB6yP2wjYc+6vI/mN/YoVmeyw
         Q859jmNCDTfn+F3SPTSVljXChv1i8x5CEQtbTdynledYiBG3SjkqwYBbViUUfcpMPw70
         VKFZW43yYuiJfCZoQ3J2LlEnVRk2yNLWPgP5hgD7A7/diG/cxDafaH4MvPNJcdi+m+sj
         mrSA==
X-Gm-Message-State: ACgBeo0p40fshInUueUZbJgWXeKprfjGE1Y/cuu/7HaRhL/pbLgdNT9Z
        nHY0/qXa7/zz7VTLkBrnHGYMxLAjZmkXpZqCPtod99bAZOo=
X-Google-Smtp-Source: AA6agR57DkuDbCN2s20x5pRyTYxxXbXqSv1N4hr3gpM4FZXXY/u6mn1anMqn/b6jPFE17eUhBWPbCZgjfxyJMI8F8Kw=
X-Received: by 2002:a25:dbcb:0:b0:6a8:e19f:9938 with SMTP id
 g194-20020a25dbcb000000b006a8e19f9938mr430485ybf.158.1662497233152; Tue, 06
 Sep 2022 13:47:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220906132821.713989422@linuxfoundation.org>
In-Reply-To: <20220906132821.713989422@linuxfoundation.org>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Tue, 6 Sep 2022 21:46:37 +0100
Message-ID: <CADVatmMTbnOm1bHWdbxVZ26QfbjyhhB+_ZRBMM53GicJczE5=Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/107] 5.15.66-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Sep 6, 2022 at 2:37 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Sep 2022 13:27:58 +0000.
> Anything received after that time might be too late.

My test pipelines are still running, but x86_64 allmodconfig failed
with gcc-12 with the error:

drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c: In function
'ipc_protocol_dl_td_process':
drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:406:13: error: the
comparison will always evaluate as 'true' for the address of 'cb' will
never be NULL [-Werror=address]
  406 |         if (!IPC_CB(skb)) {
      |             ^
In file included from drivers/net/wwan/iosm/iosm_ipc_imem.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_protocol.h:9,
                 from drivers/net/wwan/iosm/iosm_ipc_protocol_ops.c:6:
./include/linux/skbuff.h:794:33: note: 'cb' declared here
  794 |         char                    cb[48] __aligned(8);

It will need dbbc7d04c549 ("net: wwan: iosm: remove pointless null check").


-- 
Regards
Sudip
