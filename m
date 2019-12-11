Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878B311BCC8
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 20:22:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726524AbfLKTWm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 14:22:42 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:34756 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbfLKTWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Dec 2019 14:22:42 -0500
Received: by mail-pl1-f196.google.com with SMTP id x17so1809700pln.1
        for <stable@vger.kernel.org>; Wed, 11 Dec 2019 11:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=B/omuTxLtHKj4Gwws5UIGOHbZDI0wtiUpMOSLjh5SOg=;
        b=bZgefzwEkt66di7eEoIMJi8Eb8O7LjWSQwmfhJVeDwUDKmw0C6bCkAA5kq0eZHIKsy
         fqPf6/5C8AO+W6y+hXe7JScra3Z8OWGSC7gvGbGW51dybvkxb7Y6rBbELKRH7obCZcWq
         /8P/13zoFwrN/6ftLXNcGZDfZbzlCa/8ZbjRDFl6UYrDqClHU7SdjrOQlgBwSZMX7nqm
         riXHtP1QlB9Xgc/Fhh3Di8/z8bEoDlm5gGrpMibEISDrxtczHKbUtlPjcF3oFrCgnyu6
         Tuxtzpb3m1hnxSu7TR1HAHXtTeT75eNtUal3VPwGOxuxvUSQRGKYnqHDVBVljoVyW88k
         a5xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=B/omuTxLtHKj4Gwws5UIGOHbZDI0wtiUpMOSLjh5SOg=;
        b=Y9tarVdqJmcU+OZPA6H1G0mxuVsutWBFsFdvvaOj01D/kIu7eTZEmU0gud1yFfAfRt
         ExDlZhCWYl8aYZ6/1PYljwXjd8+5wV/brPLH6VVPxZBFhWheLGM74wZjXlDsmizZZe2O
         QiISdtrtKpkPahqQCUcCHZMv5qExG8ZOpvG5EzWSOYi04cLu7oMB1VSio5PYAKiKLO5P
         kiCl+tGR9QY7USVTBo2Q6QH/GHjccm4kWenNf9in/82OoMcAF1/gx0YGJu9Nms17lI/Q
         Kybreqt+QkCgU5dQR2sjvxKzvVwbwb8QIMFck8yk8SeHnK9GQbt9FSLpuj8PHawKvhbX
         3+rA==
X-Gm-Message-State: APjAAAW8+PEUYCWrsDs0oQn2aQ619vL/kai5VD0gyveyQjXtmoPEMw3r
        fF2YsdZeOyEGmEjcv6K9/4w2gQ==
X-Google-Smtp-Source: APXvYqyX3BF+YrPnd9mOB8VeUOnacPqiHgPI5cziuwV5GAgotQQt7bXy8qJSwgEE+a7+bmAWTBFgaw==
X-Received: by 2002:a17:90a:1992:: with SMTP id 18mr5425701pji.46.1576092161690;
        Wed, 11 Dec 2019 11:22:41 -0800 (PST)
Received: from debian ([122.164.82.31])
        by smtp.gmail.com with ESMTPSA id a10sm3948864pgm.81.2019.12.11.11.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 11:22:40 -0800 (PST)
Date:   Thu, 12 Dec 2019 00:52:32 +0530
From:   Jeffrin Jose <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org,
        jeffrin@rajagiritech.edu.in
Subject: Re: [PATCH 5.3 000/105] 5.3.16-stable review
Message-ID: <20191211192232.GA14178@debian>
References: <20191211150221.153659747@linuxfoundation.org>
 <20191211161605.GA4849@debian>
 <20191211182852.GA715826@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191211182852.GA715826@kroah.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 11, 2019 at 07:28:52PM +0100, Greg Kroah-Hartman wrote:
> that's really odd.  How are you building this, from the git tree, or the
> tarball generated?
git tree
https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git


> And I still see that file in the 5.3 tree, what do you mean it was
> deleted?

may be during "git checkout linux-5.3.y" or may be i did "git pull" inside that branch

that was a git status which showed "D" at the start of a few lines
and one of that lines showed that file.
i also checked that path locally and found it was not there

--
software engineer
rajagiri school of engineering and technology
