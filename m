Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4C68552F7E
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 12:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiFUKNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 06:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349204AbiFUKN2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 06:13:28 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4164286D6
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:13:27 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id n1so17962068wrg.12
        for <stable@vger.kernel.org>; Tue, 21 Jun 2022 03:13:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=Oy4sU8NOneycJF+zMpgoufiBPg/no/hPTqhePYKhqNU=;
        b=BkVL880bdSJ4wvIey0hGJ2z60vYflilY8Z+Vzo72Gxqci1k0ygO8O/Liw/BcEsV/qK
         KimPATg3ehI/rbmk7A9gtBKwkkTm4W+WwpGOTq8lVqh5IXCQRBPlwSRLwLfiAs8iSjFV
         7o4EV7RuAz3cLa9RaQ2SzM+fb/6DLmAGsRFjUsy9sWIzpdTF+2pkBuoLBN0bg06Np7Pq
         z5RSs3E80tfXuWfBuwVZM95QW2h69uKNosiaf13VZ8ivpAsilFJSdHI0k/kHR6SbZE/F
         RKEMBAhRplXI+ixrcfkd/MChapvrvW5vQO6eheQZJAjVnRwZV1nin8eJcpn2RG+JaTJI
         RriA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=Oy4sU8NOneycJF+zMpgoufiBPg/no/hPTqhePYKhqNU=;
        b=RwZzWTQQXiqHdY6qE5WAvbiTbC1M4KDMBqo9rjCSG5qnhG+7tNK4llt8rir1O8y9d9
         8Yzqi8IspPo+GwpHJDAtU61XCIaNdDsnbOjgRYr2V36PXlUPpPnZEpZrbq+cVotxygRA
         HDTsdoDVmHCHUXnvgBMZ5KiaFBfZciOYl2Qom/Ok98BuasowFb1C3m5R1sxZLrHYpPWF
         7ApWIvgVgkT/4F2cBdQV5t+6I1pp0QvXwPc4n6g4ZyQQZcD3i/YMpfZwIBvaUg3AkA/B
         lDAz68OyT2/Q7UtyOUH/EvDMgSS6TGfU5RUMIbV7y4IbmDLP1IFz80vGFLDxSb/jKPtx
         cZcA==
X-Gm-Message-State: AJIora8xaKpcwhmAAqul4N31VRcLZ0mKVl5zbmqcSAxmqlF58npRDwtI
        U5hKEbacGf4tuVaCV+ccEWEgb0jS8bI=
X-Google-Smtp-Source: AGRyM1uy0X6recXMFx1Ry8RR8d4dNppuCng/IHZhxGS+BPdMWPMfeONoSRkJp9v8Pcor4PSiv6SGaw==
X-Received: by 2002:adf:f186:0:b0:21b:960b:8f9 with SMTP id h6-20020adff186000000b0021b960b08f9mr3885873wro.70.1655806406499;
        Tue, 21 Jun 2022 03:13:26 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id r13-20020a5d4e4d000000b0021b96cdf68fsm1750729wrt.97.2022.06.21.03.13.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 03:13:26 -0700 (PDT)
Date:   Tue, 21 Jun 2022 11:13:24 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: patch request for 5.18-stable to fix gcc-12 build (hopefully last)
Message-ID: <YrGZxGoKgKxcvVTG@debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

The following will be needed for the gcc-12 builds:

ee3db469dd31 ("wifi: rtlwifi: remove always-true condition pointed out by GCC 12")
32329216ca1d ("eth: sun: cassini: remove dead code")
dbbc7d04c549 ("net: wwan: iosm: remove pointless null check")


With this 3 applied on top of v5.18.6-rc1 allmodconfig for x86_64, riscv
and mips passes. (not checked other arch yet)

Will request you to add these to 5.18-stable queue please.

--
Regards
Sudip
