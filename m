Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09372ADB7E
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 16:50:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726758AbfIIOua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 10:50:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:36335 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726370AbfIIOua (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 10:50:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id y22so9323364pfr.3;
        Mon, 09 Sep 2019 07:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c6vg0xyrV5io4e6dwW3Gj3nqy/OfmxiGQBslfR4XQAI=;
        b=P3ttrEWQ1NUjbe9T2KyhQlGrp0uCYvhjgRtYPCgAPeq1ei8pw0Epda9rY38MJ1OLog
         rWUEGTxOKnEjILjXQojBsmaX6wbnEGQMcfdwp2KAKZG5F/2Na9P22QOzEUwvwShk1vXw
         tmCkDu2f5YSSp1mOtXbfMXbKRYQZrZDBVs0UR4oh1o7D5u7CTl2YWsRCStph26n+evCz
         XSYEnj7oeEH1xWD7rpfug40FXkYEZ46ZFXMPwUj/wDGRa9dj3QKYvNjGGVdHo+DMeNUT
         3gVOEbLCVzdPphOtBKTh3Ggh9aMft0hp0dfQbulE8Sbc71Ob6+Ix+fBTkIKK6FCDuNEz
         TX7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=c6vg0xyrV5io4e6dwW3Gj3nqy/OfmxiGQBslfR4XQAI=;
        b=i/mNa9CRxB0Qqdyak471DY3f2QwYQiavnckPhqP8LTzbLtZG05WwvJ0ZkmtNSan9rl
         Vgtj5Jw+pljzg9NysU3hypaqF4agqf1sr0SDhpsdNhpkrpyk+aGuB5wIlDqD8qiPKkvc
         wz+lh5VSuikQed0JybWAdGDOw2wYTFQmavI0wmzuZWviRDwXCNbTA4BB3Ze+xWGFin8y
         J58JO4KTkRAIlzydH37MuPGgbeAEj7LL+UEutjN5kXXHJgr09/F6o8wniwaF/NB+sHap
         pkn/z7uml0jQeLOcCG+Hs3J0kbkic7CUUmnHyO6QxrIoL0FEHlhBiLuiTvYB7iuiBirt
         SNZQ==
X-Gm-Message-State: APjAAAUB9/Qw0B3EPGelInB0Yq00VuI8pIS2eZnnMWuGAJ5OwurXgAWS
        gGidqmfpmEgrlHwA9rPLPkc=
X-Google-Smtp-Source: APXvYqxWp+Q2iWXBsQYbnjuOJdO6kGWWZzA2jCbKktLRjTQmwyXNUe8qwtYbs3lWwULNG3rs0yXQ8g==
X-Received: by 2002:a65:5188:: with SMTP id h8mr22004182pgq.294.1568040629438;
        Mon, 09 Sep 2019 07:50:29 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.34])
        by smtp.gmail.com with ESMTPSA id w21sm13854496pjh.19.2019.09.09.07.50.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 07:50:28 -0700 (PDT)
Date:   Mon, 9 Sep 2019 20:20:22 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 4.14 00/40] 4.14.143-stable review
Message-ID: <20190909145022.GC4050@bharath12345-Inspiron-5559>
References: <20190908121114.260662089@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86 machine. NO dmesg regressions found.

Thank you
Bharath
