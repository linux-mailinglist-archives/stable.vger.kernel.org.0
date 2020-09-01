Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA8B1258623
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 05:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725993AbgIADXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Aug 2020 23:23:55 -0400
Received: from sonic303-20.consmr.mail.ne1.yahoo.com ([66.163.188.146]:46102
        "EHLO sonic303-20.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725987AbgIADXz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Aug 2020 23:23:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1598930634; bh=gwxlS81WjlUspm9tadTKFDi9QvJMJ/R7PcMmGob6kJA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KoDWfefiRDJGU3kGNmqSg/HD9wVo09U8OPVg3w/m+N3WPwToHiKE0k9B+XTMGPabjGtWmAnfIrfL4ouKS0MjveZ7b4PEB87jjL6smRjhEwWYOow3jhSa0BFgA1C/17VcoAWSjf3KKuHGdcM07aqeXro+dXnR9RpjFZ7/rm5+xzVdhiBCEIdMy03eeLHcIsh5aorXNGct6l786HdvbSRsbQifRsjAN3AkjDE/MGJWgbuoGbDj0CvL2zFW+jRLJHuHo9Zt+qhXpyELy/fBtC1oWDneKUCtfo3Dr5BWad2U7Bbtg2U7Xzr7EdeXcdxyaU6zdmE0gl4s3jJwVbQ6PnaQEg==
X-YMail-OSG: LzQRTS8VM1kr3yA_QOUm92N8W79oqyWOHUsX5KSTZqe7j_7L_ZBZxQ3E4_BnTQ2
 0Pk_P6VM2TyKw4c.Kyk1z55k4_8CJwgmwMhkCanBtjozoUoJNp0hKrUASIKFPSruIFEEgQgOxS2I
 D5z.45y2Pq3EqegWHGjyFv05a3xNTbqaDhcb646vY.pfceJ77vHj5pLM3J.WRN0W_G5HYAvcgN5a
 c1OKqU1rMU0dtFNYhf.tcuNl1OKF8REuScgjlSg4jZXUiW5B9IvoXdU44o0u2TibbvEAVns3W3kM
 DvQCZoIOMbbFlY6b9c05x3MT4t4W3Auv2FulahodOPkrRGz8fT2BdqVi1kUhY6qWyOi31C3rKdo0
 U7svw.X9VeMFXI9_cRThJqo32QSvymaSdK_F3bRou8rHvX4X0LITDAn5QwkGsAOKOUkigbC3tnoU
 1SKvuSl7AEgvKawkNf1r5RXxMXZ7qSZapFywil9Hsuo_yvcqP7CBC1k0CR7nsr6_NHzkojk1m5F4
 2rqLecBwSK35n3U86WedvKG_W3TqexxJV_8xDMI7kvFc8JJpMEJppWXyA5DspnTpHaPGOz1cON.0
 m4QUfdubIDqC255.0EKzsge2DdwXM7KKIIqmT4tR.Meoddz6loupKSRS_XHyv0jpIVh.Vaa71U_Y
 btCItiK_98ZktCxRT_Dj.nMrADHk_U.9bd.zS8pvUnaCvpzzKLrjhUzycU4sRWOqAHIt73az_Ypz
 aB4mqq0uKlo2DX6zrw3APBTrUioJm2MPKgolUMwfpT641IxyV4gyEE3py._xniKCqeDnHbGpttwL
 fLXXJ5H1XqhLLpb7pj0nuuqNyzMxXej4mrneDQ9SFh8CEVt3qPzMuT.4yJnacxj_4ip1.9aaIBCr
 Ad8GKZccBL0U5U5qWov2IQ7aI8OLvU2uV_bLBUmla.YkkBzi38_9Kk6WWxlwc7SfZVap_J8k66Pp
 VvnD4GkgydXYGRZk8kK7MvlRGnL0ZaAJbMyBX32oX2jxy9gDIUpa_9Fwt5.Irb9E3LDITh9J73CZ
 lOiXIuAQTKCrzcawRMOhC0k2CR9bpZPXnjlxnQFWwLo6cNntQtImBmn0c96_ZxO1MpcTmZdk3M1L
 y_pjqr2dsmNBwpOEmJtszE0rFLA5YMkMaqKv9R3rokucET5sH0Tnu3GFYTvQb1z.I_D6uw7BdTNI
 luFL_PvERe5haU.873Mcmv8XyxlQnskmjE27SC0zlP51TcKAGniNTKT92gZcusSRBCu4pEzyZxm3
 T6SgXNmepilrenSSHFLfxOpbJTrLQz12veMs529TPZ2LAgqQOYA.DXpQAJVY71jZ6za_RMghpvEL
 cZocrYros.0PpNbQtzZPxaWhfQjnSxY1TqCceC7irHYuA8tX6MdcwgS6L0lYffxLryMQNS2n3sOo
 HYf1_F4deEKQaOLFI3hfjmTmiZ0jFYUlLiwETwL7kWcfPmlBqaSGryEa1b6o9sptoUN4S5ADdfi.
 oVnwOww--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic303.consmr.mail.ne1.yahoo.com with HTTP; Tue, 1 Sep 2020 03:23:54 +0000
Date:   Tue, 1 Sep 2020 03:23:53 +0000 (UTC)
From:   Mrs Chantel Dauda <zainabmadina.golf444@gmail.com>
Reply-To: mrschantel.dauda1989@gmail.com
Message-ID: <1499950521.1272317.1598930633275@mail.yahoo.com>
Subject: Dear Friend.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1499950521.1272317.1598930633275.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16565 YMailNodin Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.135 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Friend.


I am Mrs. Chantel Dauda. am sending this brief letter to solicit your

partnership to transfer $16.7 million US Dollars. I shall send you

more information and procedures when I receive positive response from

you.    MY PRIVATE I.D (mrschantel.dauda1989@gmail.com)


MRS CHANTEL DAUDA 
