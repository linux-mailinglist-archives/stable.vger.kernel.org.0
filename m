Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2543514EF28
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 16:08:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728686AbgAaPIE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 10:08:04 -0500
Received: from mail-wr1-f51.google.com ([209.85.221.51]:38456 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729036AbgAaPIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 10:08:04 -0500
Received: by mail-wr1-f51.google.com with SMTP id y17so9009120wrh.5
        for <stable@vger.kernel.org>; Fri, 31 Jan 2020 07:08:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=3qlvkBwHN7/F1+WuOJyWoy7MZxQs2fQrW4puAUaQD74=;
        b=RTXmCOSkvknxyFxFBGcAU6h52SO87fYuUiwqqV90wdUVU4LGkf9BlBUgUO6nWWQpg0
         faxSWuNwLzCadEfRKUEVUvRlfzEXd68EVX7UDXH7bv5KbpvAppQDb18No60SkdMnhOfE
         HD8bzm3FbWjLESSvi4t2g4NsaiJiyHibPzkQyEHnlX7evfLpYUHQ2MFtkdmXMI7i6Z3T
         SE+FNC63w/4gPUOchH+2U/2HqTm350ArnquhXfwKOaDWKLuigVTYY9Werm54A/7mwUQ2
         5rz/8glSrdUMMz+7RnxuoEwQYdOGsxCOHRxlJ/OtDxS8dKfCU7BnoxOEKB2vfb44iukE
         C43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=3qlvkBwHN7/F1+WuOJyWoy7MZxQs2fQrW4puAUaQD74=;
        b=c42xTSrN6LlXzW0VZsjbeaOL0OpZqW1syWgIT8gfrtJcjp+kOPsI518VV/yaJ60uUD
         bxnIMTe1+J8Qoup2xhyQAVtWxoRPrmqtCu3YsTiew03vmOI38OhFUnO/64Ayc7JNp65/
         +2qDFDJnnWaHSB+SgOVBfL/bSm3BkkflO5N5IjoilLENCArgR+BQJg/8lTE/vJfMtjUZ
         0JFG0MxETXLBdm9xHLldKQha/LUtj6LHDZkQ7/T0wa7tLoRS3CxHpCalpeWLgzLKaUco
         83mZ4q/NbecffqTUs/xfLShwLE6o1QU56I/eMn8Zw/glt22Tp5IirhNrNTZRNW2Wg8bX
         ergw==
X-Gm-Message-State: APjAAAW4ZB+cXBKTT3Y0DfWg8ufKCDEnaSiXIQZHIvwUm9jcX4jgm942
        Gaov9iiVMb4+gtAwaYhPavhZeA==
X-Google-Smtp-Source: APXvYqx+o748mbaFCTje42eSwbkuD8Zgo/z7Aapx2Uui6tte1AukyhQ20cDlGeFKJZc0i5+Tu2unHg==
X-Received: by 2002:a5d:5263:: with SMTP id l3mr12462661wrc.405.1580483281846;
        Fri, 31 Jan 2020 07:08:01 -0800 (PST)
Received: from dell ([2.27.35.227])
        by smtp.gmail.com with ESMTPSA id g7sm12089738wrq.21.2020.01.31.07.08.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jan 2020 07:08:01 -0800 (PST)
Date:   Fri, 31 Jan 2020 15:08:09 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     Julia Lawall <julia.lawall@inria.fr>
Cc:     kbuild-all@lists.01.org, philip.li@intel.com,
        gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [lee:android-3.18-preview 136/224]
 drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
 preceded by free on line 460 (fwd)
Message-ID: <20200131150809.GF3548@dell>
References: <alpine.DEB.2.21.2001311542130.2236@hadrien>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.DEB.2.21.2001311542130.2236@hadrien>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 31 Jan 2020, Julia Lawall wrote:

> The code on line 462 looks suspicious.

Thank you Julia.

Have you already reported this to the other Stable Maintainers?

This issue appears to affect; 4.4, 4.9, 4.14 and 4.19.

> ---------- Forwarded message ----------
> Date: Fri, 31 Jan 2020 16:56:26 +0800
> From: kbuild test robot <lkp@intel.com>
> To: kbuild@lists.01.org
> Cc: Julia Lawall <julia.lawall@lip6.fr>
> Subject: [lee:android-3.18-preview 136/224]
>     drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference
>     preceded by free on line 460
> 
> CC: kbuild-all@lists.01.org
> BCC: philip.li@intel.com
> TO: Lee Jones <lee.jones@linaro.org>
> 
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/lee/linux.git android-3.18-preview
> head:   356017eeb20d27b17d236ff6b31c0b7d24dff865
> commit: 752c36757aa40c2f669d7da128aae237f9fd3318 [136/224] media: si470x-i2c: add missed operations in remove
> :::::: branch date: 18 hours ago
> :::::: commit date: 6 days ago
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> Reported-by: Julia Lawall <julia.lawall@lip6.fr>
> 
> >> drivers/media/radio/si470x/radio-si470x-i2c.c:462:25-30: ERROR: reference preceded by free on line 460
> 
> # https://git.kernel.org/pub/scm/linux/kernel/git/lee/linux.git/commit/?id=752c36757aa40c2f669d7da128aae237f9fd3318
> git remote add lee https://git.kernel.org/pub/scm/linux/kernel/git/lee/linux.git
> git remote update lee
> git checkout 752c36757aa40c2f669d7da128aae237f9fd3318
> vim +462 drivers/media/radio/si470x/radio-si470x-i2c.c
> 
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  449
> 9dcb79c2eedb5b Tobias Lorenz      2009-08-10  450
> 9dcb79c2eedb5b Tobias Lorenz      2009-08-10  451  /*
> 9dcb79c2eedb5b Tobias Lorenz      2009-08-10  452   * si470x_i2c_remove - remove the device
> 9dcb79c2eedb5b Tobias Lorenz      2009-08-10  453   */
> 4c62e9764ab403 Greg Kroah-Hartman 2012-12-21  454  static int si470x_i2c_remove(struct i2c_client *client)
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  455  {
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  456  	struct si470x_device *radio = i2c_get_clientdata(client);
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  457
> fe2137dd4e6e4b Joonyoung Shim     2009-12-10  458  	free_irq(client->irq, radio);
> 4967d53dbbcebf Hans Verkuil       2012-05-04  459  	video_unregister_device(&radio->videodev);
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09 @460  	kfree(radio);
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  461
> 752c36757aa40c Chuhong Yuan       2019-11-10 @462  	v4l2_ctrl_handler_free(&radio->hdl);
> 752c36757aa40c Chuhong Yuan       2019-11-10  463  	v4l2_device_unregister(&radio->v4l2_dev);
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  464  	return 0;
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  465  }
> cc35bbddfe10f7 Joonyoung Shim     2009-08-09  466
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

-- 
Lee Jones [李琼斯]
Linaro Services Technical Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
