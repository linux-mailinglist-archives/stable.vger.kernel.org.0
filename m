Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C199ADB9B
	for <lists+stable@lfdr.de>; Mon,  9 Sep 2019 17:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbfIIPAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Sep 2019 11:00:44 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:34096 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbfIIPAo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Sep 2019 11:00:44 -0400
Received: by mail-pl1-f194.google.com with SMTP id d3so6678526plr.1;
        Mon, 09 Sep 2019 08:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3y2rn1zyYl3FAzWIcsCn6DEvZ0xQkk0FsNB4R1a2HOw=;
        b=sju/fsmzFeuln3oDPHjWrDJHJV9S+fwLxGDZ6pBnbql+lQpadH1OVehGHusvRnBjUF
         G2LAy3W58B0e+vpZdPSJc2OEgQTLTFRE5Z8WXBLD/HB3PlbZ/bhsENZC4C9Lm3qfjEFL
         yOwJwiDzOF1WjcANwZ2ox6VoNUFpVZRo9Chl/Jpbq4EpL30TsmYNGVXCmudLkIEdcbSY
         fQC16hIASQOMNI7ST9bWF6LD3S9QItLxKPrRiL5I/YYXZfrYUiJRlTRU7DuUgiiPEOBW
         viKTuXYO1lFPrZpSXrRAO61bvOdSK7pBzqlUV/Um++PuXIH0iVg861FMfC4/vCTJ8W7b
         4bfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=3y2rn1zyYl3FAzWIcsCn6DEvZ0xQkk0FsNB4R1a2HOw=;
        b=ssYu35/SR4cjWTnbfougT/0oEjIo1Q39jofNVPF90U2WkCb5/zWHdgxUgcvbtTGx6S
         vbkpWwCLX/+AkuT98AvDr18jQ7+/TYIvQe5t/yb3ADYE1Uqoa4JIs0GdSSWtVWWhpuOx
         pKeV+VB0R/1hmFY2nLiaO3WCjghp6lvSnhA/2eOUF1rQK+YfzGV2wp1/ijVu9wEEbcXj
         h4D8puTEmjfuUAJrc78xXoGA5mtJQ3LtZJG/UAk4XOUtoVP3sC73K3+Er5p1YghX+D3D
         Y92WNVcFANj3zkJtMP0k+UtgkztyJU83keihZJ9kjJTSNQzXZdftMuueQM5I4tdF+V8b
         gBeA==
X-Gm-Message-State: APjAAAVA54THSwSj8vlnyXkuFgNx3lPuO1BoJ5BXpdqU+wC7aCM/mYsx
        n+mDcUSgwjp8jrmoHZtwQHI=
X-Google-Smtp-Source: APXvYqysixYJW3hO5mxkT900jdU1u0swYvzaAA32rkA2ZuxFqKfdLjiHOO3QrMuPjdQycstrQPyNMA==
X-Received: by 2002:a17:902:b696:: with SMTP id c22mr17194095pls.199.1568041243453;
        Mon, 09 Sep 2019 08:00:43 -0700 (PDT)
Received: from bharath12345-Inspiron-5559 ([103.110.42.36])
        by smtp.gmail.com with ESMTPSA id s97sm11552891pjc.4.2019.09.09.08.00.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 09 Sep 2019 08:00:43 -0700 (PDT)
Date:   Mon, 9 Sep 2019 20:30:36 +0530
From:   Bharath Vedartham <linux.bhar@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.2 00/94] 5.2.14-stable review
Message-ID: <20190909150036.GD4050@bharath12345-Inspiron-5559>
References: <20190908121150.420989666@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Built and booted on my x86 machine. No dmesg regressions found.

Thank you
Bharath
