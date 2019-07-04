Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043DB5F247
	for <lists+stable@lfdr.de>; Thu,  4 Jul 2019 07:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727211AbfGDF1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Jul 2019 01:27:09 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:38192 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725920AbfGDF1J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Jul 2019 01:27:09 -0400
Received: by mail-pl1-f194.google.com with SMTP id 9so2457378ple.5;
        Wed, 03 Jul 2019 22:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5V6sp/Xn1ehTfKdKO8pHQn3yd0IpqqgMKDiU6XfEjuM=;
        b=pQoiBPAoz3f7gMgnQBHqCZWwVsQxmHNjEmr795Bw2apLw/b7wT567IAAGcK6dRAgHN
         6Jv/+gIO7pcJEX/GEOV/iG2Mvp/iY6q8Ba6rD7JjCwHByBbf6WOwdGhVpXuw2EXkTvI+
         Nuas8eeaepf/NP+H8yHZ2M8K/mj7/khEh8JILt8E0kLmM6BSQZBSbAcWuTgeblJ6FxaG
         RyuGYMT2uOQwHE4acUG5MfpGmhq0EgB2X+3ew8AdS7IwDfcKGHI0e4wqzKVPhRxlfzH1
         Pvww4Qyf3ogqfH4QMwcG4Lywi1756Yxpb7nD3XHtFCMiQXxwkMTP5xMZGpPIDEvqkFEI
         FFcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=5V6sp/Xn1ehTfKdKO8pHQn3yd0IpqqgMKDiU6XfEjuM=;
        b=JPIQqYvhFTijcF6G+bqJE2yr7GFucscYVhWCx1xB2z9CROSja5gPl9E+G0U/XsjGiL
         /fp5AH9X+AwgX2dON1UAVpt2GS+3Nb3yFxXBbjiZirbnFUtA1MiU/ehfaciLO9EzMaw0
         afv8LXYfhTs9/P5myBy510lCDKKe6C/rccej8Fh1DvPS3i0FNjvLteCsUEOJvYUJMWQk
         YrbYYEOlNOLfeEk1kVM/oZoabeWIUrYJnfQdAz2/YGP6yqy/asCApIWseEkkwhcicP/v
         GhcnvTeoKAaZHGasp7dBSmnjP17/yTxBbnoBDnfwkMzyKkTdtWDdKd9cUTjVKuYTcC7H
         sGAg==
X-Gm-Message-State: APjAAAVQgoDgJYzsuYCR4wbdiVfcqOdQiqpvBQLUwD9q4BTsQ8ijzg7a
        JY8w16pckviHq8h2SopEzj9YtusA
X-Google-Smtp-Source: APXvYqx4cHF/IqFQbIGf7LA+w/OTmpOJ/pFXiZL5F1pk6MY1mm6s+jJp2HBmq9lGoXzRncoC+T/9CQ==
X-Received: by 2002:a17:902:9346:: with SMTP id g6mr2958617plp.61.1562218028794;
        Wed, 03 Jul 2019 22:27:08 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.33])
        by smtp.gmail.com with ESMTPSA id v27sm4328910pgn.76.2019.07.03.22.27.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Jul 2019 22:27:08 -0700 (PDT)
Date:   Thu, 4 Jul 2019 10:56:58 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/43] 4.14.132-stable review
Message-ID: <20190704052658.GA16449@bharath12345-Inspiron-5559>
References: <20190702080123.904399496@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190702080123.904399496@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Booted and tested in my x86 systems. No regressions.
