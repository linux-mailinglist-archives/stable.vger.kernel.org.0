Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5876545A98D
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 18:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbhKWRFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 12:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238738AbhKWRDQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 12:03:16 -0500
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A1ACC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 09:00:08 -0800 (PST)
Received: by mail-il1-x129.google.com with SMTP id j21so16829161ila.5
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 09:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iLHLHWKHiwYgbmujSictcAHHSbLU16KvbZp8U/9JcGk=;
        b=QbFXDxYWJZN99PQY6ABTrQx5FneH79JfrkZtYQXQDm1N2Fv/QW+ofWY90QaZki9NGd
         nXGOIyw96WAJxfn1NUFDcoFM6yLASMTUbi1CtGeOluW2G0Jzp/UT1djAncg5aQaWlx7s
         3GLt5x1W9qz7pSKSL6+UZjgAEacOdsxIbxjb8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iLHLHWKHiwYgbmujSictcAHHSbLU16KvbZp8U/9JcGk=;
        b=xGsBtSr9zF/malLDQtJPDgGq8DdfFTYlspm/bDMIZY4jgEX1CygHOMKIuak1MRiEVM
         0pHKq55IWPaU8wms3WBhIJBHZ/qrse6ohwp/H843Bi3jH/7aaD/NNurTp11An3Y7u4p1
         P35T8j2jqL/NKFa+9va6RaR8UJ/ygD2JmfCsJcgC6EyP+S2NPA527oIkB5lrylfLFHvw
         UKE7Z8RsGSpm0umRrnnNlGCBb0bxrfyiShvlwi4bWpXsl1YYRGk5cZkwdXa9MMdzf9IR
         9XLuyaBbRr5YHSUirSMsJuOHf8x64fd/FYporY+bJRRiIvev9lLaN5oocVTBcgSDhaGk
         Hf4A==
X-Gm-Message-State: AOAM531cY0bH2si7f/Euc3P4RI5FceNAVwL2GyGVz1WEVOxjdg5jWa/j
        5pTta8GKKfya+ruuo8OPWlNou7arSmVsgQ==
X-Google-Smtp-Source: ABdhPJz4bmSYkIbgYpod9FvivM9PrvAkq/4dwrhFjhUehaaa3wuPyvymmt2MQMO65Z5EZbPHHbtXcg==
X-Received: by 2002:a05:6e02:18ce:: with SMTP id s14mr6562964ilu.142.1637686807764;
        Tue, 23 Nov 2021 09:00:07 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-181.dsl.bell.ca. [216.209.220.181])
        by smtp.gmail.com with ESMTPSA id b3sm5442455ile.26.2021.11.23.09.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 09:00:07 -0800 (PST)
Date:   Tue, 23 Nov 2021 12:00:05 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     "Fernandes, Francois" <Francois.Fernandes@conduent.com>
Cc:     "webmaster@kernel.org" <webmaster@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [External] - Re: EOL Kernels versions
Message-ID: <20211123170005.36v2fspqis2ahjgn@meerkat.local>
References: <BN8PR20MB26744F4622B7219F22A2DA64F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123143647.zcnrlsnlmfl5yhhu@meerkat.local>
 <BN8PR20MB26741ED4B21328F5F64CFC14F8609@BN8PR20MB2674.namprd20.prod.outlook.com>
 <20211123153254.pqz4ii7jhf3c5ltz@meerkat.local>
 <BN8PR20MB2674E60612008BC2114D3A3DF8609@BN8PR20MB2674.namprd20.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <BN8PR20MB2674E60612008BC2114D3A3DF8609@BN8PR20MB2674.namprd20.prod.outlook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 23, 2021 at 04:53:43PM +0000, Fernandes, Francois wrote:
> OK, 
> So in this case we 'only' have to follow the version for the distribution date and move this at each EOL distribution date.
> 
> I understood that this kind of evolution is easier than a kernel evolution.
> Could you confirm please ?

I cannot confirm this, since the answer will depend on what exactly you need
for your project. If you are not shipping custom hardware and do not require a
custom kernel build, then you should stick with the kernel that comes with the
distribution you are using and upgrade whenever the next Debian version is
released.

Hope this helps.

-K
