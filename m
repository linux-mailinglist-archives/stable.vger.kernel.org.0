Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0BBF37F456
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 10:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231357AbhEMIry (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 04:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231273AbhEMIrx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 04:47:53 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122BCC061574;
        Thu, 13 May 2021 01:46:44 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id v12so26128060wrq.6;
        Thu, 13 May 2021 01:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3FkFy0c36SNhKbaRVomCfeyMIyqDh+C+ksOUdL6isdA=;
        b=uRUOfMIm3YAmzG3b1DJ5EDwxYrODW/oQgURnEgtwvSGcwCWF0aSBykyEwzwkCX9Ix9
         P7fJ8odof5aeOyHqJepJbxtGZNP/K78bi9H8NqkB0Op4H0DGkNW+RjUV219vlcws+8J0
         G/chDThxhqOn74KGUcG42vA59EA53zGHo5g+5+wiHinkiykZjdkcbylRfBeWQ/aUCdsT
         8Cg5V6zd0+27uKqs0BmAO5vlCuN+KKz9FATqDkgnXc+FrfaNt6J6YmqnL3e8gzX6bOqU
         V1l8+ngMKcaZhq+ngqyCzpYGMiynHmrC4gg1Brdulbef3btiErFUxlnQxy8Grpk03hkB
         OXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3FkFy0c36SNhKbaRVomCfeyMIyqDh+C+ksOUdL6isdA=;
        b=c2XSNlVdi9ecZc0qyFJGQC/f9WuWvb7CO0jL3agwCZlQtLUqU0jWpG8QFyvc9cZ6xY
         e3WfUYmyidoT+u9ITnZAEjbdPHzOD9iq05bRVMIo7J65PuwaQ2lJ4vqwi9KRogxobjPV
         QoXzFUN7rKegUkdAS9E5+e8AvitYmp4ByhyzIYu0F3LAHdeGzdF/oeE6GfSwazgZXILa
         PEzl0Yp03H35siBb1tIAGguul71kLKzO5E0mXAvP/1OMN2txVz155jeCVqCbPVgTeDtI
         5gTeI5u4q2SmUZVBpkR7OmpvNivNpFvZdXcd1zbe3QAnXivohUBaOrKnXhbBZi+rGPYU
         o5rQ==
X-Gm-Message-State: AOAM533PbYFmZ1qfuk3knZwDbTavTC/FKB4qJWFo2lq6nGrNSnnqb3XH
        eK0L8Fu7B09M+jjKhqPO7vFl2PYrhJ/SdQ==
X-Google-Smtp-Source: ABdhPJxQE1dmnFYIo3vYWj4A0ou3NIx+kYJbEzBcLu36qWgpMLDaj/vSsVuHkqMvaRnY4IGUs6eTTw==
X-Received: by 2002:a05:6000:50d:: with SMTP id a13mr49363978wrf.130.1620895602843;
        Thu, 13 May 2021 01:46:42 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id z5sm2187769wrn.69.2021.05.13.01.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 May 2021 01:46:42 -0700 (PDT)
Date:   Thu, 13 May 2021 09:46:40 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Huacai Chen <chenhuacai@kernel.org>,
        "Maciej W. Rozycki" <macro@orcam.me.uk>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: Re: [PATCH 5.10 052/530] MIPS: Reinstate platform `__div64_32 handler
Message-ID: <YJzncHQfODFWvZt2@debian>
References: <20210512144819.664462530@linuxfoundation.org>
 <20210512144821.451207008@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512144821.451207008@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, May 12, 2021 at 04:42:42PM +0200, Greg Kroah-Hartman wrote:
> From: Maciej W. Rozycki <macro@orcam.me.uk>
> 
> commit c49f71f60754acbff37505e1d16ca796bf8a8140 upstream.

This is breaking the mips build of malta_qemu_32r6_defconfig. Reverting
the patch fixes the build.


--
Regards
Sudip
