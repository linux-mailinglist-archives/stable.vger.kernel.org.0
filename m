Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3530A14F4C5
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 23:34:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726246AbgAaWeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 17:34:13 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55414 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726202AbgAaWeN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 17:34:13 -0500
Received: by mail-pj1-f68.google.com with SMTP id d5so3501537pjz.5
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 14:34:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qHwLMgyQPf9S7w4WbZP4aPjIld/v+Drkd6KsGVLfTRk=;
        b=TAzJij5TvX03n0DX+NG7XH8i+sI9pZ5N3cXiDbwWpQN0KAIoQKoDfOqjP/lUnVQkTW
         xyP9jjonEDwIUj5xUdb8w33Qn/qATITZjS/erX7IBRakn+r1SEx/lOfGaZR/8xb5NsVi
         U+7jafWA8Vw8Gdnx/9BJBmhXAFmofAxb0eUXgwRZ0yA+2qwXVhaKnLOzpTcQTEGRxYU/
         jd8Mc0Cb97k7fCvyLmIYqK6K/TUdleaEKd6TfKTruf6dY5qSJzfswtLDLtJLOJcT08lD
         MRziTjzvffZ3FMMFeCFIe03nLiv//XNNCvZdKn+Znpmoax4jOdUbJG7PUM5XgOyyCRgJ
         156Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qHwLMgyQPf9S7w4WbZP4aPjIld/v+Drkd6KsGVLfTRk=;
        b=DR65VvepyxSFVlmv7JQQRnz8IZm0jBvhErLf0JZmjqR3GBrBiSZ0e9/BuqnXHLlsBx
         7cZQKKNc+w1MVNr62sW3EDo365nuQ4vcuF5/HAsN11JV+IeMCYLYu9yUSvI9NXmRRSbE
         VqCgXqcrO6PAckbvP4E6QAvDC/8pPvZxVHN0NoYyi2sbrVEIfbGPd8SBLeZD1eodlkB9
         qwnBYnvEdY9wm+N933rE5gdDzB21gWBclKJ6t3u7iTJhohjE1+a4mBmx2E3KEiDyRjkd
         kOeepgVk6eR1s5kmqRTr0tbfilnAeLGkHcCFmkODTkhwC9VBLG1UGS7LO/PqrM6mNAcv
         zmxQ==
X-Gm-Message-State: APjAAAUYIEaCvu8O5uI95qITwbHt0e7XnUfLei+2pQ4v+QpXry9ZUsOs
        GSTZzgbhIn25lcxjArsA4caLzQ==
X-Google-Smtp-Source: APXvYqwuiYxLCHCh6fjR7LbWTgMTBUD3gm41x8xDrAAiRlQK/Jb+gxFiQLu/RXpqE0A+WwwyLvb0ZQ==
X-Received: by 2002:a17:902:5a0c:: with SMTP id q12mr12362460pli.301.1580510051986;
        Fri, 31 Jan 2020 14:34:11 -0800 (PST)
Received: from debian ([122.174.183.46])
        by smtp.gmail.com with ESMTPSA id q8sm11260417pfs.161.2020.01.31.14.34.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 14:34:11 -0800 (PST)
Date:   Sat, 1 Feb 2020 04:03:59 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.5 00/56] 5.5.1-stable review
Message-ID: <20200131223359.GA2670@debian>
References: <20200130183608.849023566@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130183608.849023566@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 07:38:17PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.5.1 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
> and the diffstat can be found below.

hello ,

compiled and booted 5.5.1-rc1+ . No new errors according to "sudo dmesg -l err"

--
software engineer
rajagiri school of engineering and technology

