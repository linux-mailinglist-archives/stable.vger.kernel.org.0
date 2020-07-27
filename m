Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6567722E3F5
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 04:19:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbgG0CTE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Jul 2020 22:19:04 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:34676 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgG0CTE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Jul 2020 22:19:04 -0400
Received: from epcas1p2.samsung.com (unknown [182.195.41.46])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200727021900epoutp01fab7a55c961fed304107a8487965e217~leoG3Ja-F2517325173epoutp01M
        for <stable@vger.kernel.org>; Mon, 27 Jul 2020 02:19:00 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200727021900epoutp01fab7a55c961fed304107a8487965e217~leoG3Ja-F2517325173epoutp01M
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1595816340;
        bh=7V53jiR43hfWpIhdINTRe9CgtKWNsaYeYzzDH0xnzfk=;
        h=Subject:To:Cc:From:Date:In-Reply-To:References:From;
        b=Y6LHgZUmA/ywJ50L7sApnmxKwk8OIH4sPOE6+n2gDbdES96zoVTM4bfDYOJRinWwv
         L4bc5fEFk1EyOGbci+ktgidQAcG/J/HnKzAcXSCn4yEUG8uVuPO6ILHtu9G9hVm7my
         yHYmbEnCnu9jcBWQh41uH6LUxfmd+QuiIT+BsUtk=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTP id
        20200727021859epcas1p158344ab0304d521fb6486123834e360b~leoF3fVaj0501105011epcas1p1l;
        Mon, 27 Jul 2020 02:18:59 +0000 (GMT)
Received: from epsmges1p3.samsung.com (unknown [182.195.40.153]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4BFNlj0nktzMqYlp; Mon, 27 Jul
        2020 02:18:57 +0000 (GMT)
Received: from epcas1p4.samsung.com ( [182.195.41.48]) by
        epsmges1p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        BD.EE.29173.0993E1F5; Mon, 27 Jul 2020 11:18:56 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20200727021855epcas1p228cc1cd17deca91c98b98c2ffef6b509~leoB7PaAO1164811648epcas1p23;
        Mon, 27 Jul 2020 02:18:55 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200727021855epsmtrp2f792b19cde9b5d40da49933b102a6822~leoB6f-P42362523625epsmtrp2S;
        Mon, 27 Jul 2020 02:18:55 +0000 (GMT)
X-AuditID: b6c32a37-9cdff700000071f5-d6-5f1e39907ed0
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        12.B9.08303.E893E1F5; Mon, 27 Jul 2020 11:18:55 +0900 (KST)
Received: from [10.113.221.102] (unknown [10.113.221.102]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200727021854epsmtip1a941e554ce7469aaeced0da7d6ac2dcf~leoBpzmrm1960419604epsmtip1B;
        Mon, 27 Jul 2020 02:18:54 +0000 (GMT)
Subject: Re: [PATCH] PM / devfrq: Fix indentaion of devfreq_summary debugfs
 node
To:     linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     chanwoo@kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, stable@vger.kernel.org
From:   Chanwoo Choi <cw00.choi@samsung.com>
Organization: Samsung Electronics
Message-ID: <f36a3413-74b7-74f6-e87d-b19d000cb3e0@samsung.com>
Date:   Mon, 27 Jul 2020 11:30:39 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:59.0) Gecko/20100101
        Thunderbird/59.0
MIME-Version: 1.0
In-Reply-To: <20200713073112.6297-1-cw00.choi@samsung.com>
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjk+LIzCtJLcpLzFFi42LZdljTQHeCpVy8wZKLQhYTb1xhsTjb9Ibd
        4vKuOWwWn3uPMFrcblzBZrFg4yNGBzaPTas62Tz6tqxi9Pi8SS6AOSrbJiM1MSW1SCE1Lzk/
        JTMv3VbJOzjeOd7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwdor5JCWWJOKVAoILG4WEnfzqYo
        v7QkVSEjv7jEVim1ICWnwLJArzgxt7g0L10vOT/XytDAwMgUqDAhO+PJy7iC26oVG3ofsTQw
        /hXvYuTkkBAwkdi24TxbFyMXh5DADkaJ7Yc72UESQgKfGCW6VwRAJD4zSnw8soodpmPhzDao
        ol2MEocOsUMUvWeUuDnxJRNIQlggSGLX6wVgRSICVhKn/3cwg9jMAqkSX28sBYuzCWhJ7H9x
        gw3E5hdQlLj64zEjiM0rYCcxYeZysDksAqoSE259BbNFBcIkTm5rgaoRlDg58wkLiM0JNH/d
        umUsEPPFJW49mc8EYctLbH87hxnkOAmBRg6J7/uOAS3mAHJcJK6tU4Z4Rlji1fEtUI9JSXx+
        t5cNwq6WWHnyCBtEbwejxJb9F1ghEsYS+5dOZgKZwyygKbF+lz5EWFFi5++5jBB7+STefe1h
        hVjFK9HRJgRRoixx+cFdJghbUmJxeyfbBEalWUi+mYXkg1lIPpiFsGwBI8sqRrHUguLc9NRi
        wwJj5KjexAhOkFrmOxinvf2gd4iRiYPxEKMEB7OSCC+3qEy8EG9KYmVValF+fFFpTmrxIUZT
        YPhOZJYSTc4Hpui8knhDUyNjY2MLE0MzU0NDJXHef2fZ44UE0hNLUrNTUwtSi2D6mDg4pRqY
        wmrDNRRudB8PXVSRrZ9p9kN4a+Zc5axgj7s/V93VWFUh+CUpbqb6bhtnyzt77fu635333ipz
        oN3Q9nlVk3eZteShwootWfldS9PyghYlS7Kkc+jsbn1uLbs6S08movTl6rbEfd72TLNi3Dao
        9rw+xvhh0xf7bZ9vfj0yWeyT8XsuzkOeqm+YzKKSLz7cltEh9lOyrWvJ5+qfZ3Zv1+C317wX
        e67OWMW+Utp8bvq+GU9TZ6raneDRtODettWuXWrOqdiNHh2u7UttOpPeawfk7vn/Mu74zdpq
        7xkWbbOEV5ttqxdLzvUxS9Vq/vs3OlPmgsQlvgzRu+VZG39dFfrp3fWW28om5lhsUKzXbyWW
        4oxEQy3mouJEAJmdyBIZBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrELMWRmVeSWpSXmKPExsWy7bCSnG6/pVy8waXLzBYTb1xhsTjb9Ibd
        4vKuOWwWn3uPMFrcblzBZrFg4yNGBzaPTas62Tz6tqxi9Pi8SS6AOYrLJiU1J7MstUjfLoEr
        48nLuILbqhUbeh+xNDD+Fe9i5OSQEDCRWDizjR3EFhLYwSix8hYvRFxSYtrFo8xdjBxAtrDE
        4cPFXYxcQCVvGSWebd7ABFIjLBAksev1ArBeEQEridP/O5hBbGaBVIk5q+axQjT0Mkpc37IM
        rIhNQEti/4sbbCA2v4CixNUfjxlBbF4BO4kJM5eDDWURUJWYcOsrmC0qECaxc8ljJogaQYmT
        M5+wgNicQMvWrVvGArFMXeLPvEtQi8Ulbj2ZzwRhy0tsfzuHeQKj8Cwk7bOQtMxC0jILScsC
        RpZVjJKpBcW56bnFhgVGeanlesWJucWleel6yfm5mxjB0aKltYNxz6oPeocYmTgYDzFKcDAr
        ifByi8rEC/GmJFZWpRblxxeV5qQWH2KU5mBREuf9OmthnJBAemJJanZqakFqEUyWiYNTqoFp
        w7l4lZe3Xy/5Ei4XbFCv8fe5y80Q1s/T1h9yuXGkiK06csVX/emzfLtC6z0yvcuWMNR8K7zz
        YT7bkrblrYrpdyZWPmY8FbbFhlNoi9yjswf+PguKVfj1k71LLfAg0woBJ4Gta28E1n+KFV3V
        +dX2r/zppo3aJxjFefdoRxb/bHDhUby4SbPyqP+z6FShWcEZuTGfdvrvtd29TdfE5/6mrTfK
        d57cc/Oe3amS0r2pv7snnH2a9KZgtlRIpIjuxI6jplaM/7R2iZQ71u+KO+vvP+NmyKHnV1cF
        vrzebRR65bzhm0Ph2Qf/TpJ1OCRaVZiVLnmzfFr9hbI1Rxe0X0+c3X3p5is27jn9fXe2e7q6
        K7EUZyQaajEXFScCAB4VPbAFAwAA
X-CMS-MailID: 20200727021855epcas1p228cc1cd17deca91c98b98c2ffef6b509
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82
References: <CGME20200713071942epcas1p14a9a1d2017e2e5005f7146f5bed09c82@epcas1p1.samsung.com>
        <20200713073112.6297-1-cw00.choi@samsung.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/13/20 4:31 PM, Chanwoo Choi wrote:
> The commit 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name
> as devfreq(X) for sysfs"") roll back the device name from 'devfreqX'
> to device name explained in DT. After applied commit 66d0e797bf09,
> the indentation of devfreq_summary debugfs node was broken.
> 
> So, fix indentaion of devfreq_summary debugfs node as following:
> 
> For example on Exynos5422-based Odroid-XU3 board,
> $ cat /sys/kernel/debug/devfreq/devfreq_summary
> dev                            parent_dev                     governor        polling_ms  cur_freq_Hz  min_freq_Hz  max_freq_Hz
> ------------------------------ ------------------------------ --------------- ---------- ------------ ------------ ------------
> 10c20000.memory-controller     null                           simple_ondemand          0    413000000    165000000    825000000
> soc:bus_wcore                  null                           simple_ondemand         50     88700000     88700000    532000000
> soc:bus_noc                    soc:bus_wcore                  passive                  0     66600000     66600000    111000000
> soc:bus_fsys_apb               soc:bus_wcore                  passive                  0    111000000    111000000    222000000
> soc:bus_fsys                   soc:bus_wcore                  passive                  0     75000000     75000000    200000000
> soc:bus_fsys2                  soc:bus_wcore                  passive                  0     75000000     75000000    200000000
> soc:bus_mfc                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
> soc:bus_gen                    soc:bus_wcore                  passive                  0     88700000     88700000    266000000
> soc:bus_peri                   soc:bus_wcore                  passive                  0     66600000     66600000     66600000
> soc:bus_g2d                    soc:bus_wcore                  passive                  0     83250000     83250000    333000000
> soc:bus_g2d_acp                soc:bus_wcore                  passive                  0            0     66500000    266000000
> soc:bus_jpeg                   soc:bus_wcore                  passive                  0            0     75000000    300000000
> soc:bus_jpeg_apb               soc:bus_wcore                  passive                  0            0     83250000    166500000
> soc:bus_disp1_fimd             soc:bus_wcore                  passive                  0            0    120000000    200000000
> soc:bus_disp1                  soc:bus_wcore                  passive                  0            0    120000000    300000000
> soc:bus_gscl_scaler            soc:bus_wcore                  passive                  0            0    150000000    300000000
> soc:bus_mscl                   soc:bus_wcore                  passive                  0            0     84000000    666000000
> 
> Cc: stable@vger.kernel.org
> Fixes: commit 66d0e797bf09 ("Revert "PM / devfreq: Modify the device name as devfreq(X) for sysfs"")
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---
>  drivers/devfreq/devfreq.c | 11 ++++-------
>  1 file changed, 4 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
> index ce82bdb5fa5c..2ff35ec1b53b 100644
> --- a/drivers/devfreq/devfreq.c
> +++ b/drivers/devfreq/devfreq.c
> @@ -1839,8 +1839,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
>  	unsigned long cur_freq, min_freq, max_freq;
>  	unsigned int polling_ms;
>  
> -	seq_printf(s, "%-30s %-10s %-10s %-15s %10s %12s %12s %12s\n",
> -			"dev_name",
> +	seq_printf(s, "%-30s %-30s %-15s %10s %12s %12s %12s\n",
>  			"dev",
>  			"parent_dev",
>  			"governor",
> @@ -1848,10 +1847,9 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
>  			"cur_freq_Hz",
>  			"min_freq_Hz",
>  			"max_freq_Hz");
> -	seq_printf(s, "%30s %10s %10s %15s %10s %12s %12s %12s\n",
> +	seq_printf(s, "%30s %30s %15s %10s %12s %12s %12s\n",
> +			"------------------------------",
>  			"------------------------------",
> -			"----------",
> -			"----------",
>  			"---------------",
>  			"----------",
>  			"------------",
> @@ -1880,8 +1878,7 @@ static int devfreq_summary_show(struct seq_file *s, void *data)
>  		mutex_unlock(&devfreq->lock);
>  
>  		seq_printf(s,
> -			"%-30s %-10s %-10s %-15s %10d %12ld %12ld %12ld\n",
> -			dev_name(devfreq->dev.parent),
> +			"%-30s %-30s %-15s %10d %12ld %12ld %12ld\n",
>  			dev_name(&devfreq->dev),
>  			p_devfreq ? dev_name(&p_devfreq->dev) : "null",
>  			devfreq->governor_name,
> 

Applied it. Thanks.

-- 
Best Regards,
Chanwoo Choi
Samsung Electronics
