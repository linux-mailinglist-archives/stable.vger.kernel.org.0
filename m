Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0FFB13D2EE
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 04:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbgAPDzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 22:55:08 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:41536 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728925AbgAPDzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 22:55:08 -0500
Received: by mail-pg1-f176.google.com with SMTP id x8so9202148pgk.8
        for <stable@vger.kernel.org>; Wed, 15 Jan 2020 19:55:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=j3nHEu1DU/xMbec55Y07qbW5B/4W1nCMQUwpX2IVI74=;
        b=Jqw6oHzrsJJO4jHPliq4gkZ1Zo5LW9KWwgCbcyVCWOduILa4LKi7vHAP5aDDVHk99Z
         CjjZAj1StWn6uaMMrlm3O4XtgoBGy6shhpruZTuAIXTw+/De1QsrHGtUP1wkpkBk9hcq
         ExXc8cMQ/pcBTU9NcYTWUKkY8Q95MeJ0zl1aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=j3nHEu1DU/xMbec55Y07qbW5B/4W1nCMQUwpX2IVI74=;
        b=Yz10J+vu/LzhM/3JGFEoopMGuxgV0FFGznVmFRQL+Pb1UN7ApVGsbu5/qx3Xsgn9J8
         PdmIi7jxIL2GVJEyh3x2vUfrzBqcn5yIVLb4nfACTW6XF8H7vNqf90TTysQ8C/muEQqU
         mJLmUkEYDPizWuVSh9cZvdCbuCZ13wncyb70f+WN3U5CI3ofmBJkLPfrFLobo20yTN3n
         g+tT+OEj+CPH4xOXxWl1KZJ5jSGR76vYnPTyEpM9m+12+VHKW/ZYRxpijuHkrryIao4I
         FtFo32fh5sku15oXEhSLDHHEc1aPaWCzk/U6WcuDtcEnRlCoWB6RZZc4SoPqmpaMYk65
         h1uw==
X-Gm-Message-State: APjAAAUBfZUs7SXMP4opv6ONqKkxQBsLQTAHj1DPFE5px905lxtin1jw
        ph4IMrWvdulQ6d87GHBt1egCUovjgYFzCw==
X-Google-Smtp-Source: APXvYqzHg6+U/fMUvdmA6pMLptZKXSE7mpJ3WfvjU9KOIkqNUAoy+kqfI9oS3zVI9pbvDCAsR/i9Yg==
X-Received: by 2002:a63:6d8d:: with SMTP id i135mr36926733pgc.90.1579146907396;
        Wed, 15 Jan 2020 19:55:07 -0800 (PST)
Received: from google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id g24sm24140650pfk.92.2020.01.15.19.55.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2020 19:55:06 -0800 (PST)
Date:   Wed, 15 Jan 2020 19:55:02 -0800
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org,
        christian.koenig@amd.com, michel.daenzer@amd.com,
        Jerry.Zhang@amd.com, ray.huang@amd.com, alexander.deucher@amd.com
Subject: ac1e516d5a4c ("drm/ttm: fix start page for huge page check in
 ttm_put_pages()")
Message-ID: <20200116035501.GA39586@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

The patch :
a66477b0efe5 ("drm/ttm: fix out-of-bounds read in ttm_put_pages() v2")

has been applied to linux-4.19.y. However, 2 follow-up fixes have not been applied.

Could the following two fixes be applied to linux-4.19.y? These commits are present
in linux-5.4.y. These patches do not have to be applied to linux-4.14.y.

ac1e516d5a4c ("drm/ttm: fix start page for huge page check in ttm_put_pages()")
453393369dc9 ("drm/ttm: fix incrementing the page pointer for huge pages")


Thanks,
- Zubin
